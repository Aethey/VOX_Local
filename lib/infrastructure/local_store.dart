import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../domain/models.dart';
import '../domain/ports.dart';
import '../domain/transcript_text.dart';
import '../domain/transcript_timeline.dart';

class SqliteLocalStore implements LocalStore {
  SqliteLocalStore._(this.db);
  final Database db;
  final _changes = StreamController<void>.broadcast();
  final _recordChanges = StreamController<void>.broadcast();
  static Future<SqliteLocalStore> open(
    String path, {
    DatabaseFactory? factory,
  }) async {
    final db = await (factory ?? databaseFactory).openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 2,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute('ALTER TABLE jobs ADD COLUMN session_id TEXT');
            await _createRecordingSchema(db);
            await _migrateRecordings(db);
          }
        },
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE settings (key TEXT PRIMARY KEY, value TEXT NOT NULL)',
          );
          await db.execute(
            'CREATE TABLE segments (id TEXT PRIMARY KEY, session_id TEXT NOT NULL, sequence INTEGER NOT NULL, data TEXT NOT NULL, UNIQUE(session_id, sequence))',
          );
          await db.execute(
            'CREATE TABLE jobs (id TEXT PRIMARY KEY, profile_id TEXT NOT NULL, phase TEXT NOT NULL, due INTEGER NOT NULL, created INTEGER NOT NULL, session_id TEXT NOT NULL, data TEXT NOT NULL)',
          );
          await db.execute('CREATE INDEX jobs_due ON jobs(phase, due)');
          await db.execute(
            'CREATE TABLE logs (id INTEGER PRIMARY KEY AUTOINCREMENT, data TEXT NOT NULL)',
          );
          await _createRecordingSchema(db);
        },
      ),
    );
    return SqliteLocalStore._(db);
  }

  static Future<void> _createRecordingSchema(Database db) async {
    await db.execute(
      'CREATE TABLE recordings (id TEXT PRIMARY KEY, created INTEGER NOT NULL, updated INTEGER NOT NULL, title TEXT NOT NULL, preview TEXT NOT NULL, analysis_enabled INTEGER NOT NULL DEFAULT 0, analysis_pending INTEGER NOT NULL DEFAULT 0, data TEXT NOT NULL)',
    );
    await db.execute(
      'CREATE INDEX recordings_updated ON recordings(updated DESC)',
    );
    await db.execute(
      'CREATE INDEX recordings_pending ON recordings(analysis_enabled, analysis_pending, updated)',
    );
    await db.execute('CREATE TABLE deleted_recordings (id TEXT PRIMARY KEY)');
    await db.execute('CREATE INDEX jobs_session ON jobs(session_id)');
  }

  static DateTime _createdAt(String id) {
    final stamp = int.tryParse(id.split('-').first);
    if (stamp != null && stamp > 946684800000000 && stamp < 4102444800000000) {
      return DateTime.fromMicrosecondsSinceEpoch(stamp, isUtc: true);
    }
    return DateTime.now().toUtc();
  }

  static String _preview(String text) {
    final clean = TranscriptText.clean(text).replaceAll('\n', ' ');
    return clean.length > 180 ? clean.substring(0, 180) : clean;
  }

  static RecordingSummary _record(Map<String, Object?> row) =>
      RecordingSummary.fromJson(jsonDecode(row['data'] as String));
  static Map<String, Object?> _recordRow(RecordingSummary value) => {
    'id': value.id,
    'created': value.createdAt.millisecondsSinceEpoch,
    'updated': value.updatedAt.millisecondsSinceEpoch,
    'title': value.title,
    'preview': value.preview,
    'analysis_enabled': value.analysisEnabled ? 1 : 0,
    'data': jsonEncode(value.toJson()),
  };

  static Future<void> _migrateRecordings(Database db) async {
    final saved = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: ['settings'],
      limit: 1,
    );
    final defaults = saved.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(saved.single['value'] as String) as Map<String, dynamic>;
    final enabled = defaults['analysisEnabled'] == true;
    final groups = await db.rawQuery(
      'SELECT session_id, COUNT(*) AS count FROM segments GROUP BY session_id',
    );
    for (final group in groups) {
      final id = group['session_id'] as String;
      final first = await db.query(
        'segments',
        where: 'session_id = ?',
        whereArgs: [id],
        orderBy: 'sequence ASC',
        limit: 1,
      );
      final last = await db.query(
        'segments',
        where: 'session_id = ?',
        whereArgs: [id],
        orderBy: 'sequence DESC',
        limit: 1,
      );
      final head = TranscriptSegment.fromJson(
        jsonDecode(first.single['data'] as String),
      );
      final tail = TranscriptSegment.fromJson(
        jsonDecode(last.single['data'] as String),
      );
      final created = _createdAt(id);
      final record = RecordingSummary(
        id: id,
        createdAt: created,
        updatedAt: created,
        preview: _preview(head.text),
        segmentCount: group['count'] as int,
        duration: tail.end,
      );
      await db.insert('recordings', {
        ..._recordRow(record),
        'analysis_pending': 0,
      });
    }
    for (final row in await db.query('jobs', orderBy: 'created ASC')) {
      final job = TranscriptText.job(
        AnalysisJob.fromJson(jsonDecode(row['data'] as String)),
      );
      await db.update(
        'jobs',
        {'session_id': job.sessionId},
        where: 'id = ?',
        whereArgs: [job.id],
      );
      final existing = await db.query(
        'recordings',
        where: 'id = ?',
        whereArgs: [job.sessionId],
        limit: 1,
      );
      final old = existing.isEmpty
          ? RecordingSummary(
              id: job.sessionId,
              createdAt: job.createdAt,
              updatedAt: job.createdAt,
              preview: job.segments.isEmpty
                  ? ''
                  : _preview(job.segments.first.text),
              segmentCount: job.segments.length,
              duration: job.segments.isEmpty ? 0 : job.segments.last.end,
            )
          : _record(existing.single);
      final updated = old.copyWith(
        analysisEnabled: enabled,
        analysisProfile: job.profile,
        analysisTemplate: job.template,
      );
      await db.insert('recordings', {
        ..._recordRow(updated),
        'analysis_pending': enabled ? 1 : 0,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      // Older jobs contain their source text; retain it if an old session row is missing.
      for (final segment in job.segments) {
        await db.insert('segments', {
          'id': segment.id,
          'session_id': segment.sessionId,
          'sequence': segment.sequence,
          'data': jsonEncode(segment.toJson()),
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }
  }

  @override
  Stream<void> get recordingChanges => _recordChanges.stream;
  void _recordChanged() {
    if (!_recordChanges.isClosed) _recordChanges.add(null);
  }

  @override
  Future<List<RecordingSummary>> recordings({
    int limit = 40,
    int offset = 0,
    String query = '',
  }) async {
    final escaped = query
        .trim()
        .replaceAll('\\', '\\\\')
        .replaceAll('%', '\\%')
        .replaceAll('_', '\\_');
    final encoded = jsonEncode(query.trim());
    final body = encoded
        .substring(1, encoded.length - 1)
        .replaceAll('\\', '\\\\')
        .replaceAll('%', '\\%')
        .replaceAll('_', '\\_');
    return (await db.query(
      'recordings',
      orderBy: 'updated DESC, id DESC',
      limit: limit,
      offset: offset,
      where: escaped.isEmpty ? null : "(title LIKE ? ESCAPE '\\' OR preview LIKE ? ESCAPE '\\' OR EXISTS (SELECT 1 FROM segments s WHERE s.session_id = recordings.id AND s.data LIKE ? ESCAPE '\\'))",
      whereArgs: escaped.isEmpty
          ? null
          : ['%$escaped%', '%$escaped%', '%"text":"%$body%'],
    )).map(_record).toList();
  }

  @override
  Future<RecordingSummary?> recording(String id) async {
    final rows = await db.query(
      'recordings',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : _record(rows.single);
  }

  @override
  Future<void> saveRecording(RecordingSummary value) async {
    await db.transaction((tx) async {
      if ((await tx.query(
        'deleted_recordings',
        where: 'id = ?',
        whereArgs: [value.id],
        limit: 1,
      )).isNotEmpty) {
        throw const FormatException('recordingNotFound');
      }
      final rows = await tx.query(
        'recordings',
        where: 'id = ?',
        whereArgs: [value.id],
        limit: 1,
      );
      var pending = value.analysisEnabled ? 1 : 0;
      if (rows.isNotEmpty) {
        final old = _record(rows.single);
        if (old.analysisEnabled == value.analysisEnabled &&
            old.analysisScope == value.analysisScope) {
          pending = rows.single['analysis_pending'] as int;
        }
        if (old.analysisScope != value.analysisScope) {
          final obsolete = await tx.query(
            'jobs',
            where: "session_id = ? AND phase NOT IN ('succeeded','cancelled')",
            whereArgs: [value.id],
          );
          for (final row in obsolete) {
            final oldJob = AnalysisJob.fromJson(
              jsonDecode(row['data'] as String),
            );
            await tx.update(
              'jobs',
              _row(oldJob.update(phase: JobPhase.cancelled)),
              where: 'id = ?',
              whereArgs: [oldJob.id],
            );
          }
        }
        value = value.copyWith(
          createdAt: old.createdAt,
          segmentCount: old.segmentCount > value.segmentCount
              ? old.segmentCount
              : value.segmentCount,
          preview: old.preview.isNotEmpty ? old.preview : value.preview,
          duration: old.duration > value.duration
              ? old.duration
              : value.duration,
        );
      }
      await tx.insert('recordings', {
        ..._recordRow(value),
        'analysis_pending': pending,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      if (value.status == RecordingStatus.recording) {
        await tx.insert('settings', {
          'key': 'currentSession',
          'value': value.id,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
    _recordChanged();
  }

  @override
  Future<void> deleteRecording(String id) async {
    await db.transaction((tx) async {
      await tx.insert('deleted_recordings', {
        'id': id,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      // Tombstones only guard against late writes from a capture that was
      // still running. Session ids start with their creation time, so old
      // entries can be pruned without a schema change.
      final now = DateTime.now().toUtc();
      for (final row in await tx.query('deleted_recordings', columns: ['id'])) {
        final old = row['id'] as String;
        if (old != id && now.difference(_createdAt(old)).inDays > 30) {
          await tx.delete(
            'deleted_recordings',
            where: 'id = ?',
            whereArgs: [old],
          );
        }
      }
      await tx.delete('segments', where: 'session_id = ?', whereArgs: [id]);
      await tx.delete('jobs', where: 'session_id = ?', whereArgs: [id]);
      await tx.delete('recordings', where: 'id = ?', whereArgs: [id]);
      await tx.delete(
        'settings',
        where: 'key LIKE ?',
        whereArgs: ['cursor:$id:%'],
      );
      await tx.delete(
        'settings',
        where: 'key = ? AND value = ?',
        whereArgs: ['currentSession', id],
      );
    });
    _changed();
    _recordChanged();
  }

  @override
  Future<List<RecordingSummary>> analysisTargets({int limit = 20}) async =>
      (await db.query(
        'recordings',
        where: 'analysis_enabled = 1 AND analysis_pending = 1',
        orderBy: 'updated ASC, id ASC',
        limit: limit,
      )).map(_record).toList();

  static Future<void> _markPlanned(
    DatabaseExecutor tx,
    String id,
    String scope,
    int sequence,
  ) async {
    final rows = await tx.query(
      'recordings',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty || _record(rows.single).analysisScope != scope) return;
    final last =
        Sqflite.firstIntValue(
          await tx.rawQuery(
            'SELECT MAX(sequence) FROM segments WHERE session_id = ?',
            [id],
          ),
        ) ??
        0;
    if (last <= sequence) {
      await tx.update(
        'recordings',
        {'analysis_pending': 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  @override
  Future<void> markAnalysisPlanned(String id, String scope, int sequence) =>
      db.transaction((tx) => _markPlanned(tx, id, scope, sequence));

  @override
  Stream<void> get jobChanges => _changes.stream;
  void _changed() {
    if (!_changes.isClosed) _changes.add(null);
  }

  @override
  Future<String?> setting(String key) async {
    final rows = await db.query(
      'settings',
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [key],
    );
    return rows.isEmpty ? null : rows.first['value'] as String;
  }

  @override
  Future<void> saveSetting(String key, String value) async {
    await db.insert('settings', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> appendSegment(TranscriptSegment segment) async {
    segment = TranscriptText.segment(segment);
    if (segment.text.isEmpty || !TranscriptTimeline.valid(segment)) return;
    await db.transaction((tx) async {
      if ((await tx.query(
        'deleted_recordings',
        where: 'id = ?',
        whereArgs: [segment.sessionId],
        limit: 1,
      )).isNotEmpty) {
        return;
      }
      final duplicate = await tx.query(
        'segments',
        columns: ['id'],
        where: 'session_id = ? AND sequence = ?',
        whereArgs: [segment.sessionId, segment.sequence],
        limit: 1,
      );
      if (duplicate.isNotEmpty) return;
      final previous = await tx.query(
        'segments',
        where: 'session_id = ? AND sequence < ?',
        whereArgs: [segment.sessionId, segment.sequence],
        orderBy: 'sequence DESC',
        limit: 1,
      );
      final next = await tx.query(
        'segments',
        where: 'session_id = ? AND sequence > ?',
        whereArgs: [segment.sessionId, segment.sequence],
        orderBy: 'sequence ASC',
        limit: 1,
      );
      if (previous.isNotEmpty &&
          !TranscriptTimeline.follows(
            segment,
            TranscriptSegment.fromJson(
              jsonDecode(previous.single['data'] as String),
            ),
          )) {
        return;
      }
      if (next.isNotEmpty &&
          !TranscriptTimeline.follows(
            TranscriptSegment.fromJson(
              jsonDecode(next.single['data'] as String),
            ),
            segment,
          )) {
        return;
      }
      await tx.insert('segments', {
        'id': segment.id,
        'session_id': segment.sessionId,
        'sequence': segment.sequence,
        'data': jsonEncode(segment.toJson()),
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      final rows = await tx.query(
        'recordings',
        where: 'id = ?',
        whereArgs: [segment.sessionId],
        limit: 1,
      );
      if (rows.isNotEmpty) {
        final old = _record(rows.single);
        final next = old.copyWith(
          segmentCount: old.segmentCount + 1,
          preview: previous.isEmpty ? _preview(segment.text) : old.preview,
          duration: segment.end > old.duration ? segment.end : old.duration,
          updatedAt: DateTime.now().toUtc(),
        );
        await tx.update(
          'recordings',
          {
            ..._recordRow(next),
            'analysis_pending': next.analysisEnabled
                ? 1
                : (rows.single['analysis_pending'] as int),
          },
          where: 'id = ?',
          whereArgs: [segment.sessionId],
        );
      }
    });
    _recordChanged();
  }

  @override
  Future<List<TranscriptSegment>> segments(String sessionId) async =>
      (await db.query(
            'segments',
            columns: ['data'],
            where: 'session_id = ?',
            whereArgs: [sessionId],
            orderBy: 'sequence ASC',
          ))
          .map(
            (r) => TranscriptText.segment(
              TranscriptSegment.fromJson(jsonDecode(r['data'] as String)),
            ),
          )
          .where((segment) => segment.text.isNotEmpty)
          .toList();
  @override
  Future<int> cursor(String key) async =>
      int.tryParse(await setting('cursor:$key') ?? '') ?? 0;
  @override
  Future<bool> enqueue(
    AnalysisJob job,
    int expectedCursor,
    String cursorKey, {
    int capacity = 100,
  }) async {
    final inserted = await db.transaction((tx) async {
      final parent = await tx.query(
        'recordings',
        where: 'id = ?',
        whereArgs: [job.sessionId],
        limit: 1,
      );
      if (parent.isEmpty) return false;
      final record = _record(parent.single);
      if (!record.analysisEnabled || record.analysisScope != job.scopeKey) {
        return false;
      }
      if ((await tx.query(
        'deleted_recordings',
        where: 'id = ?',
        whereArgs: [job.sessionId],
        limit: 1,
      )).isNotEmpty) {
        return false;
      }
      final rows = await tx.query(
        'settings',
        where: 'key = ?',
        whereArgs: ['cursor:$cursorKey'],
      );
      final current = rows.isEmpty
          ? 0
          : int.parse(rows.first['value'] as String);
      final count =
          Sqflite.firstIntValue(
            await tx.rawQuery(
              "SELECT COUNT(*) FROM jobs WHERE phase IN ('pending','running','retrying','blocked','failed')",
            ),
          ) ??
          0;
      if (current != expectedCursor || count >= capacity) return false;
      await tx.insert('jobs', _row(job));
      await tx.insert('settings', {
        'key': 'cursor:$cursorKey',
        'value': '${job.segments.last.sequence}',
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      await _markPlanned(
        tx,
        job.sessionId,
        job.scopeKey,
        job.segments.last.sequence,
      );
      return true;
    });
    if (inserted) _changed();
    return inserted;
  }

  @override
  Future<int> pendingCount() async =>
      Sqflite.firstIntValue(
        await db.rawQuery(
          "SELECT COUNT(*) FROM jobs WHERE phase NOT IN ('succeeded','cancelled')",
        ),
      ) ??
      0;

  Map<String, Object?> _row(AnalysisJob job) => {
    'id': job.id,
    'profile_id': job.profile.id,
    'session_id': job.sessionId,
    'phase': job.phase.name,
    'due': job.dueAt.millisecondsSinceEpoch,
    'created': job.createdAt.millisecondsSinceEpoch,
    'data': jsonEncode(TranscriptText.job(job).toJson()),
  };
  @override
  Future<List<AnalysisJob>> jobs({int? limit, String? sessionId}) async =>
      (await db.query(
            'jobs',
            orderBy: 'created DESC, id DESC',
            limit: limit,
            where: sessionId == null ? null : 'session_id = ?',
            whereArgs: sessionId == null ? null : [sessionId],
          ))
          .map(
            (row) => TranscriptText.job(
              AnalysisJob.fromJson(jsonDecode(row['data'] as String)),
            ),
          )
          .toList();
  @override
  Future<AnalysisJob?> claim(DateTime now, {String? scope}) async {
    final job = await db.transaction((tx) async {
      final running =
          Sqflite.firstIntValue(
            await tx.rawQuery(
              "SELECT COUNT(*) FROM jobs WHERE phase = 'running'",
            ),
          ) ??
          0;
      if (running != 0) return null;
      final rows = await tx.rawQuery(
        "SELECT j.* FROM jobs j JOIN recordings r ON r.id = j.session_id WHERE r.analysis_enabled = 1 AND j.phase IN ('pending','retrying') AND j.due <= ? AND NOT EXISTS (SELECT 1 FROM jobs b WHERE b.profile_id = j.profile_id AND b.phase = 'blocked') ORDER BY j.created ASC, j.id ASC",
        [now.millisecondsSinceEpoch],
      );
      final candidates = rows
          .map(
            (row) => TranscriptText.job(
              AnalysisJob.fromJson(jsonDecode(row['data'] as String)),
            ),
          )
          .where((job) => scope == null || job.scopeKey == scope);
      if (candidates.isEmpty) return null;
      final old = candidates.first;
      final claimed = old.update(
        phase: JobPhase.running,
        attempts: old.attempts + 1,
      );
      await tx.update(
        'jobs',
        _row(claimed),
        where: 'id = ?',
        whereArgs: [claimed.id],
      );
      return claimed;
    });
    if (job != null) _changed();
    return job;
  }

  @override
  Future<void> updateJob(AnalysisJob job) async {
    // State and result are stored in one row, hence committed atomically.
    await db.update(
      'jobs',
      _row(job),
      where: 'id = ? AND phase NOT IN (?, ?)',
      whereArgs: [job.id, JobPhase.succeeded.name, JobPhase.cancelled.name],
    );
    _changed();
  }

  @override
  Future<void> recover() async {
    final interrupted = await db.query(
      'jobs',
      where: 'phase = ?',
      whereArgs: [JobPhase.running.name],
    );
    for (final row in interrupted) {
      final job = TranscriptText.job(
        AnalysisJob.fromJson(jsonDecode(row['data'] as String)),
      );
      await updateJob(job.update(phase: JobPhase.retrying));
    }
  }

  @override
  Future<void> retryFailed(
    String profileId,
    DateTime now, {
    String? sessionId,
  }) async {
    await db.transaction((tx) async {
      final rows = await tx.query(
        'jobs',
        where:
            "profile_id = ? AND phase IN ('failed','blocked')${sessionId == null ? '' : ' AND session_id = ?'}",
        whereArgs: [profileId, ?sessionId],
      );
      for (final row in rows) {
        final job = TranscriptText.job(
          AnalysisJob.fromJson(jsonDecode(row['data'] as String)),
        );
        await tx.update(
          'jobs',
          _row(job.update(phase: JobPhase.pending, attempts: 0, dueAt: now)),
          where: 'id = ?',
          whereArgs: [job.id],
        );
      }
    });
    _changed();
  }

  @override
  Future<void> appendLog(DiagnosticEntry entry) async {
    await db.transaction((tx) async {
      await tx.insert('logs', {'data': jsonEncode(entry.toJson())});
      await tx.execute(
        'DELETE FROM logs WHERE id NOT IN (SELECT id FROM logs ORDER BY id DESC LIMIT 300)',
      );
    });
  }

  @override
  Future<List<DiagnosticEntry>> logs() async =>
      (await db.query('logs', orderBy: 'id DESC', limit: 100))
          .map((r) => DiagnosticEntry.fromJson(jsonDecode(r['data'] as String)))
          .toList();
  @override
  Future<void> close() async {
    unawaited(_changes.close());
    unawaited(_recordChanges.close());
    await db.close();
  }
}
