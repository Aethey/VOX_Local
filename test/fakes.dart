import 'dart:async';

import 'package:vox_local/domain/models.dart';
import 'package:vox_local/domain/ports.dart';
import 'package:vox_local/domain/speech.dart';

class FakeClock implements Clock {
  DateTime time = DateTime.utc(2026, 1, 1);
  @override
  DateTime now() => time;
  void advance(Duration duration) => time = time.add(duration);
}

class FixedRandom implements RandomSource {
  @override
  double nextDouble() => .5;
}

class FakeCredentials implements CredentialStore {
  final values = <String, String>{};
  @override
  Future<String?> read(String reference) async => values[reference];
  @override
  Future<void> write(String reference, String value) async {
    values[reference] = value;
  }

  @override
  Future<void> delete(String reference) async {
    values.remove(reference);
  }
}

/// In-memory store mirroring the SQLite semantics that application code
/// depends on: recording rows, analysis_pending, tombstones and cursors.
/// Jobs seeded directly into [queue] by tests may have no parent recording;
/// those are treated as schedulable so worker tests stay self-contained.
class MemoryStore implements LocalStore {
  final settings = <String, String>{};
  final transcript = <String, TranscriptSegment>{};
  final queue = <String, AnalysisJob>{};
  final records = <String, RecordingSummary>{};
  final pending = <String>{};
  final deleted = <String>{};
  final entries = <DiagnosticEntry>[];
  final events = StreamController<void>.broadcast();
  final recordEvents = StreamController<void>.broadcast();
  bool logFailure = false, writeFailure = false;
  @override
  Stream<void> get jobChanges => events.stream;
  @override
  Stream<void> get recordingChanges => recordEvents.stream;
  void _changed() {
    if (!events.isClosed) events.add(null);
  }

  void _recordChanged() {
    if (!recordEvents.isClosed) recordEvents.add(null);
  }

  @override
  Future<String?> setting(String key) async => settings[key];
  @override
  Future<void> saveSetting(String key, String value) async {
    if (writeFailure) throw StateError('fixture');
    settings[key] = value;
  }

  List<RecordingSummary> _sorted() => records.values.toList()
    ..sort((a, b) {
      final byUpdated = b.updatedAt.compareTo(a.updatedAt);
      return byUpdated != 0 ? byUpdated : b.id.compareTo(a.id);
    });

  @override
  Future<List<RecordingSummary>> recordings({
    int limit = 40,
    int offset = 0,
    String query = '',
  }) async {
    final needle = query.trim();
    final matches = _sorted().where(
      (r) =>
          needle.isEmpty ||
          r.title.contains(needle) ||
          r.preview.contains(needle) ||
          transcript.values.any(
            (s) => s.sessionId == r.id && s.text.contains(needle),
          ),
    );
    return matches.skip(offset).take(limit).toList();
  }

  @override
  Future<RecordingSummary?> recording(String id) async => records[id];

  @override
  Future<void> saveRecording(RecordingSummary value) async {
    if (writeFailure) throw StateError('fixture');
    if (deleted.contains(value.id)) {
      throw const FormatException('recordingNotFound');
    }
    final old = records[value.id];
    var next = value;
    if (old != null) {
      if (old.analysisEnabled != value.analysisEnabled ||
          old.analysisScope != value.analysisScope) {
        value.analysisEnabled
            ? pending.add(value.id)
            : pending.remove(value.id);
      }
      if (old.analysisScope != value.analysisScope) {
        for (final job in queue.values.toList()) {
          if (job.sessionId == value.id &&
              !{JobPhase.succeeded, JobPhase.cancelled}.contains(job.phase)) {
            queue[job.id] = job.update(phase: JobPhase.cancelled);
          }
        }
      }
      next = value.copyWith(
        createdAt: old.createdAt,
        segmentCount: old.segmentCount > value.segmentCount
            ? old.segmentCount
            : value.segmentCount,
        preview: old.preview.isNotEmpty ? old.preview : value.preview,
        duration: old.duration > value.duration ? old.duration : value.duration,
      );
    } else if (value.analysisEnabled) {
      pending.add(value.id);
    }
    records[next.id] = next;
    if (next.status == RecordingStatus.recording) {
      settings['currentSession'] = next.id;
    }
    _recordChanged();
  }

  @override
  Future<void> deleteRecording(String id) async {
    deleted.add(id);
    transcript.removeWhere((_, s) => s.sessionId == id);
    queue.removeWhere((_, j) => j.sessionId == id);
    records.remove(id);
    pending.remove(id);
    settings.removeWhere(
      (key, value) =>
          key.startsWith('cursor:$id:') ||
          (key == 'currentSession' && value == id),
    );
    _changed();
    _recordChanged();
  }

  @override
  Future<List<RecordingSummary>> analysisTargets({int limit = 20}) async =>
      (records.values
              .where((r) => r.analysisEnabled && pending.contains(r.id))
              .toList()
            ..sort((a, b) {
              final byUpdated = a.updatedAt.compareTo(b.updatedAt);
              return byUpdated != 0 ? byUpdated : a.id.compareTo(b.id);
            }))
          .take(limit)
          .toList();

  void _markPlanned(String id, String scope, int sequence) {
    final record = records[id];
    if (record == null || record.analysisScope != scope) return;
    final last = transcript.values
        .where((s) => s.sessionId == id)
        .fold(0, (max, s) => s.sequence > max ? s.sequence : max);
    if (last <= sequence) pending.remove(id);
  }

  @override
  Future<void> markAnalysisPlanned(
    String id,
    String scope,
    int sequence,
  ) async => _markPlanned(id, scope, sequence);

  @override
  Future<void> appendSegment(TranscriptSegment segment) async {
    if (writeFailure) throw StateError('fixture');
    if (deleted.contains(segment.sessionId)) return;
    if (transcript.containsKey(segment.id)) return;
    transcript[segment.id] = segment;
    final record = records[segment.sessionId];
    if (record != null) {
      records[record.id] = record.copyWith(
        segmentCount: record.segmentCount + 1,
        preview: record.preview.isEmpty ? segment.text : record.preview,
        duration: segment.end > record.duration ? segment.end : record.duration,
      );
      if (record.analysisEnabled) pending.add(record.id);
    }
    _recordChanged();
  }

  @override
  Future<List<TranscriptSegment>> segments(String sessionId) async =>
      transcript.values.where((s) => s.sessionId == sessionId).toList()
        ..sort((a, b) => a.sequence.compareTo(b.sequence));
  @override
  Future<int> cursor(String key) async =>
      int.tryParse(settings['cursor:$key'] ?? '') ?? 0;

  bool _schedulable(AnalysisJob job) {
    final record = records[job.sessionId];
    return record == null ||
        (record.analysisEnabled && record.analysisScope == job.scopeKey);
  }

  @override
  Future<bool> enqueue(
    AnalysisJob job,
    int expectedCursor,
    String cursorKey, {
    int capacity = 100,
  }) async {
    final count = queue.values
        .where(
          (j) => !{JobPhase.succeeded, JobPhase.cancelled}.contains(j.phase),
        )
        .length;
    if (!_schedulable(job) ||
        deleted.contains(job.sessionId) ||
        (int.tryParse(settings['cursor:$cursorKey'] ?? '') ?? 0) !=
            expectedCursor ||
        queue.containsKey(job.id) ||
        count >= capacity) {
      return false;
    }
    queue[job.id] = job;
    settings['cursor:$cursorKey'] = '${job.segments.last.sequence}';
    _markPlanned(job.sessionId, job.scopeKey, job.segments.last.sequence);
    _changed();
    return true;
  }

  @override
  Future<int> pendingCount() async => queue.values
      .where(
        (job) => !{JobPhase.succeeded, JobPhase.cancelled}.contains(job.phase),
      )
      .length;
  @override
  Future<List<AnalysisJob>> jobs({int? limit, String? sessionId}) async {
    final list =
        queue.values
            .where((j) => sessionId == null || j.sessionId == sessionId)
            .toList()
          ..sort((a, b) {
            final byCreated = b.createdAt.compareTo(a.createdAt);
            return byCreated != 0 ? byCreated : b.id.compareTo(a.id);
          });
    return limit == null ? list : list.take(limit).toList();
  }

  @override
  Future<AnalysisJob?> claim(DateTime now, {String? scope}) async {
    if (queue.values.any((j) => j.phase == JobPhase.running)) return null;
    final blocked = queue.values
        .where((j) => j.phase == JobPhase.blocked)
        .map((j) => j.profile.id)
        .toSet();
    final candidates =
        queue.values
            .where(
              (j) =>
                  {JobPhase.pending, JobPhase.retrying}.contains(j.phase) &&
                  !j.dueAt.isAfter(now) &&
                  !blocked.contains(j.profile.id) &&
                  (records[j.sessionId]?.analysisEnabled ?? true) &&
                  (scope == null || j.scopeKey == scope),
            )
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    if (candidates.isEmpty) return null;
    final job = candidates.first.update(
      phase: JobPhase.running,
      attempts: candidates.first.attempts + 1,
    );
    queue[job.id] = job;
    _changed();
    return job;
  }

  @override
  Future<void> updateJob(AnalysisJob job) async {
    if (writeFailure) throw StateError('fixture');
    final current = queue[job.id]?.phase;
    if (current != JobPhase.succeeded && current != JobPhase.cancelled) {
      queue[job.id] = job;
    }
    _changed();
  }

  @override
  Future<void> recover() async {
    for (final job in queue.values.toList()) {
      if (job.phase == JobPhase.running) {
        queue[job.id] = job.update(phase: JobPhase.retrying);
      }
    }
  }

  @override
  Future<void> retryFailed(
    String profileId,
    DateTime now, {
    String? sessionId,
  }) async {
    for (final job in queue.values.toList()) {
      if (job.profile.id == profileId &&
          (sessionId == null || job.sessionId == sessionId) &&
          {JobPhase.failed, JobPhase.blocked}.contains(job.phase)) {
        queue[job.id] = job.update(
          phase: JobPhase.pending,
          attempts: 0,
          dueAt: now,
        );
      }
    }
    _changed();
  }

  @override
  Future<void> appendLog(DiagnosticEntry entry) async {
    if (logFailure) throw StateError('fixture');
    entries.add(entry);
  }

  @override
  Future<List<DiagnosticEntry>> logs() async => entries;
  @override
  Future<void> close() async {
    await events.close();
    await recordEvents.close();
  }
}

class FakeProvider implements AnalysisProvider {
  int calls = 0, cancellations = 0;
  Future<AnalysisResult> Function(AnalysisJob)? handler;
  @override
  Future<AnalysisResult> analyze(AnalysisJob job, String credential) async {
    calls++;
    return handler == null
        ? const AnalysisResult(matched: false, findings: [])
        : handler!(job);
  }

  @override
  Future<List<String>> models(
    ProviderProfile profile,
    String credential,
  ) async => ['fixture-model'];
  @override
  void cancel() {
    cancellations++;
  }
}

class FakeSpeech implements SpeechEngine {
  final source = StreamController<SpeechEvent>.broadcast(sync: true);
  bool failStart = false;
  int starts = 0, stops = 0;
  String? lastId;
  int lastAfterSequence = 0;
  double lastOffset = 0;
  @override
  Stream<SpeechEvent> get events => source.stream;
  @override
  Future<List<OfflineModelState>> models() async => [
    const OfflineModelState('turbo'),
    const OfflineModelState('small'),
  ];
  @override
  Future<void> download(String id) async {}
  @override
  Future<void> load(String id) async {}
  @override
  Future<void> delete(String id) async {}
  @override
  Future<void> start(
    String sessionId,
    String language, {
    int afterSequence = 0,
    double offset = 0,
  }) async {
    starts++;
    if (failStart) throw StateError('fixture');
    lastId = sessionId;
    lastAfterSequence = afterSequence;
    lastOffset = offset;
  }

  @override
  Future<void> stop() async {
    stops++;
  }

  @override
  Future<void> deleteSession(String sessionId) async {}
  @override
  Future<List<TranscriptSegment>> replay(
    String sessionId,
    int afterSequence,
  ) async => [];
  @override
  Future<void> dispose() => source.close();
}

const profile = ProviderProfile(
  id: 'fixture-profile',
  provider: 'compatible',
  endpoint: 'https://example.invalid/v1',
  model: 'fixture-model',
  credentialRef: 'fixture-reference',
);
TranscriptSegment segment(
  int i, {
  String sessionId = 'session',
  String? text,
}) => TranscriptSegment(
  id: '$sessionId:$i',
  sessionId: sessionId,
  sequence: i,
  start: i.toDouble(),
  end: i + 1.0,
  text: text ?? '合成测试文本 $i',
);

/// A recording whose analysis scope matches [job] and [profile].
RecordingSummary recordingFixture({
  String id = 'session',
  RecordingStatus status = RecordingStatus.completed,
  bool analysisEnabled = true,
}) => RecordingSummary(
  id: id,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  status: status,
  analysisEnabled: analysisEnabled,
  analysisProfile: profile,
  analysisTemplate: AnalysisTemplate.presets.first,
);
AnalysisJob job({
  String id = 'job',
  JobPhase phase = JobPhase.pending,
  int attempts = 0,
  ProviderProfile configuration = profile,
}) => AnalysisJob(
  id: id,
  sessionId: 'session',
  profile: configuration,
  template: AnalysisTemplate.presets.first,
  segments: [segment(1)],
  context: '',
  createdAt: DateTime.utc(2026),
  phase: phase,
  attempts: attempts,
);
