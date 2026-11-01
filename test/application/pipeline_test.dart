import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:vox_local/application/analysis_service.dart';
import 'package:vox_local/application/session_service.dart';
import 'package:vox_local/application/settings_service.dart';
import 'package:vox_local/domain/analysis.dart';
import 'package:vox_local/domain/models.dart';

import '../fakes.dart';

class PipelineFixture {
  final store = MemoryStore();
  final engine = FakeSpeech();
  final clock = FakeClock();
  final keys = FakeCredentials();
  final provider = FakeProvider();
  late final settings = SettingsService(store, keys);
  late final session = SessionService(engine, store, clock, FixedRandom());
  late final worker = AnalysisWorker(
    store: store,
    credentials: keys,
    provider: provider,
    clock: clock,
    random: FixedRandom(),
  );
  late final analysis = AnalysisService(
    store: store,
    settings: settings,
    session: session,
    planner: AnalysisPlanner(store, clock),
    worker: worker,
    clock: clock,
  );
  Future<void> initialize() async {
    keys.values[profile.credentialRef] = 'synthetic-fixture';
    await settings.update(
      settings.value.copy(profile: profile, analysisEnabled: true),
    );
    // Scheduling is driven by the recording row, not by the selected page.
    await store.saveRecording(
      recordingFixture(status: RecordingStatus.recording),
    );
    session.emit(const SessionState(id: 'session'));
    await analysis.initialize(runTimer: false);
  }

  Future<void> dispose() async {
    await analysis.close();
    await session.close();
    await settings.close();
    await engine.dispose();
    await store.close();
  }
}

void main() {
  test('slow request does not prevent scheduling later transcript', () async {
    final fixture = PipelineFixture();
    await fixture.initialize();
    addTearDown(fixture.dispose);
    final response = Completer<AnalysisResult>();
    fixture.provider.handler = (_) => response.future;
    await fixture.store.appendSegment(segment(1));
    await fixture.analysis.tick(force: true);
    await Future<void>.delayed(Duration.zero);
    expect(fixture.provider.calls, 1);
    await fixture.store.appendSegment(segment(2));
    await fixture.analysis.tick(force: true);
    expect(fixture.store.queue.length, 2);
    expect(fixture.provider.calls, 1);
    response.complete(const AnalysisResult(matched: false, findings: []));
    await Future<void>.delayed(Duration.zero);
  });
  test('one unplannable record does not stall the others', () async {
    final fixture = PipelineFixture();
    await fixture.initialize();
    addTearDown(fixture.dispose);
    // Older record with rules over the limit is always visited first.
    await fixture.store.saveRecording(
      recordingFixture(id: 'bad').copyWith(
        updatedAt: DateTime.utc(2025),
        analysisTemplate: AnalysisTemplate.presets.first.copyWith(
          instruction: List.filled(4001, '规').join(),
        ),
      ),
    );
    await fixture.store.appendSegment(segment(1, sessionId: 'bad'));
    await fixture.store.appendSegment(segment(1));
    await fixture.analysis.tick(force: true);
    await Future<void>.delayed(Duration.zero);
    expect(fixture.store.queue.values.map((j) => j.sessionId), ['session']);
    expect(fixture.analysis.warning.value, 'invalidRulesLength');
    // The failing record is re-checked once per interval, not on every tick.
    final before = fixture.store.entries.length;
    await fixture.analysis.tick();
    expect(fixture.store.entries.length, before);
  });
  group('whole-transcript analysis', () {
    Future<PipelineFixture> finished({bool analysisEnabled = true}) async {
      final fixture = PipelineFixture();
      await fixture.initialize();
      addTearDown(fixture.dispose);
      final record = recordingFixture(analysisEnabled: analysisEnabled);
      await fixture.store.saveRecording(record);
      for (var i = 1; i <= 3; i++) {
        await fixture.store.appendSegment(segment(i));
      }
      fixture.session.emit(
        SessionState(
          id: 'session',
          record: record,
          phase: SessionPhase.completed,
          segments: await fixture.store.segments('session'),
        ),
      );
      return fixture;
    }

    test('queues one job carrying every segment and runs it', () async {
      final fixture = await finished();
      await fixture.analysis.analyzeWhole();
      await Future<void>.delayed(Duration.zero);
      final jobs = fixture.store.queue.values.toList();
      expect(jobs, hasLength(1));
      expect(jobs.single.whole, isTrue);
      expect(jobs.single.segments.map((s) => s.sequence), [1, 2, 3]);
      expect(jobs.single.context, isEmpty);
      expect(fixture.provider.calls, 1);
      // The incremental planner must not re-send the same text afterwards.
      await fixture.analysis.tick(force: true);
      expect(fixture.store.queue, hasLength(1));
    });

    test('enables analysis on a record that had it off', () async {
      final fixture = await finished(analysisEnabled: false);
      await fixture.analysis.analyzeWhole();
      await Future<void>.delayed(Duration.zero);
      expect(fixture.store.records['session']!.analysisEnabled, isTrue);
      expect(fixture.store.queue.values.single.whole, isTrue);
      expect(fixture.provider.calls, 1);
    });

    test('each run is a distinct job', () async {
      final fixture = await finished();
      await fixture.analysis.analyzeWhole();
      fixture.clock.advance(const Duration(seconds: 1));
      await fixture.analysis.analyzeWhole();
      expect(fixture.store.queue.values.where((j) => j.whole), hasLength(2));
    });

    test('rejects a transcript over the input budget', () async {
      final fixture = await finished();
      await fixture.store.appendSegment(
        segment(4, text: List.filled(12000, '长').join()),
      );
      await expectLater(
        fixture.analysis.analyzeWhole(),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            'transcriptOverBudget',
          ),
        ),
      );
      expect(fixture.store.queue, isEmpty);
    });

    test('refuses while the recording is still running', () async {
      final fixture = PipelineFixture();
      await fixture.initialize();
      addTearDown(fixture.dispose);
      fixture.session.emit(
        SessionState(
          id: 'session',
          record: recordingFixture(status: RecordingStatus.recording),
          phase: SessionPhase.recording,
        ),
      );
      await expectLater(
        fixture.analysis.analyzeWhole(),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            'finishRecordingFirst',
          ),
        ),
      );
    });
  });
  test(
    'full queue still dispatches existing work and preserves unscheduled text',
    () async {
      final fixture = PipelineFixture();
      await fixture.initialize();
      addTearDown(fixture.dispose);
      for (var i = 0; i < 100; i++) {
        fixture.store.queue['fixture-$i'] = job(id: 'fixture-$i');
      }
      await fixture.store.appendSegment(segment(2));
      await fixture.analysis.tick(force: true);
      await Future<void>.delayed(Duration.zero);
      expect(fixture.provider.calls, 1);
      expect(fixture.analysis.warning.value, 'queueFull');
      expect(
        fixture.store.settings.keys.where((k) => k.startsWith('cursor:')),
        isEmpty,
      );
    },
  );
}
