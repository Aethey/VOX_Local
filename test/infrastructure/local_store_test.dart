import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vox_local/domain/models.dart';
import 'package:vox_local/infrastructure/local_store.dart';

import '../fakes.dart';

void main() {
  late Directory directory;
  late SqliteLocalStore store;
  setUpAll(sqfliteFfiInit);
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('vox-store-test-');
    store = await SqliteLocalStore.open(
      '${directory.path}/fixture.sqlite',
      factory: databaseFactoryFfi,
    );
    // Jobs are only accepted and claimed for a recording with analysis enabled.
    await store.saveRecording(recordingFixture());
  });
  tearDown(() async {
    await store.close();
    await directory.delete(recursive: true);
  });
  test('segments are idempotent and ordered', () async {
    await store.appendSegment(segment(2));
    await store.appendSegment(segment(1));
    await store.appendSegment(segment(1));
    expect((await store.segments('session')).map((s) => s.sequence), [1, 2]);
  });
  test(
    'new records are clean and legacy records are cleaned before reading',
    () async {
      const raw = '<|startoftranscript|><|zh|><|0.00|>预算是 3.14 万元<|2.00|>';
      await store.appendSegment(segment(1, text: raw));
      final persisted = jsonDecode(
        (await store.db.query('segments')).single['data'] as String,
      );
      expect(persisted['text'], '预算是 3.14 万元');
      final legacy = segment(2, text: raw);
      await store.db.insert('segments', {
        'id': legacy.id,
        'session_id': legacy.sessionId,
        'sequence': legacy.sequence,
        'data': jsonEncode(legacy.toJson()),
      });
      expect((await store.segments('session')).map((segment) => segment.text), [
        '预算是 3.14 万元',
        '预算是 3.14 万元',
      ]);
    },
  );
  test(
    'legacy queued analysis sends clean source text and keeps evidence ids',
    () async {
      final raw = job().copyWith(
        segments: [segment(1, text: '<|0.00|>正文<|1.00|>')],
        context: '<|zh|>前文<|endoftext|>',
      );
      await store.enqueue(raw, 0, 'cursor');
      await store.db.update('jobs', {'data': jsonEncode(raw.toJson())});
      final claimed = await store.claim(DateTime.utc(2026));
      expect(claimed!.segments.single.text, '正文');
      expect(claimed.segments.single.id, raw.segments.single.id);
      expect(claimed.context, '前文');
    },
  );
  test('job reservation and cursor are atomic', () async {
    final outcomes = await Future.wait([
      store.enqueue(job(), 0, 'cursor'),
      store.enqueue(job(), 0, 'cursor'),
    ]);
    expect(outcomes.where((v) => v), hasLength(1));
    expect(await store.cursor('cursor'), 1);
    expect(await store.jobs(), hasLength(1));
  });
  test('queue capacity does not advance text cursor', () async {
    expect(await store.enqueue(job(), 0, 'cursor', capacity: 0), false);
    expect(await store.cursor('cursor'), 0);
  });
  test('only one concurrent claim succeeds', () async {
    await store.enqueue(job(), 0, 'cursor');
    final outcomes = await Future.wait([
      store.claim(DateTime.utc(2026)),
      store.claim(DateTime.utc(2026)),
    ]);
    expect(outcomes.whereType<AnalysisJob>(), hasLength(1));
  });
  test('interrupted task survives close and reopen', () async {
    await store.enqueue(job(), 0, 'cursor');
    await store.claim(DateTime.utc(2026));
    await store.close();
    store = await SqliteLocalStore.open(
      '${directory.path}/fixture.sqlite',
      factory: databaseFactoryFfi,
    );
    await store.recover();
    expect((await store.jobs()).single.phase, JobPhase.retrying);
    expect(await store.claim(DateTime.utc(2026)), isNotNull);
  });
  test('success and result committed together cannot be overwritten by late failure', () async {
    await store.enqueue(job(), 0, 'cursor');
    await store.updateJob(
      job().update(
        phase: JobPhase.succeeded,
        result: const AnalysisResult(matched: false, findings: []),
      ),
    );
    await store.updateJob(job().update(phase: JobPhase.failed));
    final saved = (await store.jobs()).single;
    expect(saved.phase, JobPhase.succeeded);
    expect(saved.result?.matched, false);
  });
  test('blocked credential stops other requests for that profile', () async {
    await store.enqueue(job(), 0, 'a');
    await store.updateJob(job().update(phase: JobPhase.blocked));
    await store.enqueue(job(id: 'other'), 0, 'b');
    expect(await store.claim(DateTime.utc(2026)), isNull);
    await store.retryFailed(profile.id, DateTime.utc(2026));
    expect(await store.claim(DateTime.utc(2026)), isNotNull);
  });
  test('diagnostic retention is bounded', () async {
    for (var i = 0; i < 310; i++) {
      await store.appendLog(
        DiagnosticEntry(time: DateTime.utc(2026), event: 'fixture'),
      );
    }
    expect((await store.logs()).length, 100);
    final count = await store.db.rawQuery('SELECT COUNT(*) AS n FROM logs');
    expect(count.single['n'], 300);
  });
}
