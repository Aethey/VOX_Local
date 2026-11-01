import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:vox_local/application/analysis_service.dart';
import 'package:vox_local/application/session_service.dart';
import 'package:vox_local/application/settings_service.dart';
import 'package:vox_local/domain/analysis.dart';
import 'package:vox_local/domain/models.dart';

import '../fakes.dart';

void main() {
  test('inactive configuration is not sent', () async {
    final store = MemoryStore();
    addTearDown(store.close);
    store.queue['old'] = job(id: 'old');
    final keys = FakeCredentials()
      ..values[profile.credentialRef] = 'synthetic-fixture';
    final provider = FakeProvider();
    final clock = FakeClock();
    final worker = AnalysisWorker(
      store: store,
      credentials: keys,
      provider: provider,
      clock: clock,
      random: FixedRandom(),
    );
    await worker.tick(scope: 'other-config:actions:1');
    expect(provider.calls, 0);
    expect(store.queue['old']!.phase, JobPhase.pending);
  });
  test('pause then resume rejects previous generation result', () async {
    final store = MemoryStore();
    addTearDown(store.close);
    store.queue['job'] = job();
    final keys = FakeCredentials()
      ..values[profile.credentialRef] = 'synthetic-fixture';
    final provider = FakeProvider();
    final pending = Completer<AnalysisResult>();
    provider.handler = (_) => pending.future;
    final worker = AnalysisWorker(
      store: store,
      credentials: keys,
      provider: provider,
      clock: FakeClock(),
      random: FixedRandom(),
    );
    final running = worker.tick();
    await Future<void>.delayed(Duration.zero);
    worker.pause();
    worker.resume();
    pending.complete(const AnalysisResult(matched: false, findings: []));
    await running;
    expect(store.queue['job']!.phase, JobPhase.retrying);
  });
  test('changing speech settings does not cancel analysis', () async {
    final store = MemoryStore();
    final engine = FakeSpeech();
    final clock = FakeClock();
    final keys = FakeCredentials()
      ..values[profile.credentialRef] = 'synthetic-fixture';
    final settings = SettingsService(store, keys);
    await settings.update(
      settings.value.copy(profile: profile, analysisEnabled: true),
    );
    final session = SessionService(engine, store, clock, FixedRandom());
    await store.saveRecording(recordingFixture());
    session.emit(const SessionState(id: 'session'));
    await store.appendSegment(segment(1));
    final provider = FakeProvider();
    final pending = Completer<AnalysisResult>();
    provider.handler = (_) => pending.future;
    final worker = AnalysisWorker(
      store: store,
      credentials: keys,
      provider: provider,
      clock: clock,
      random: FixedRandom(),
    );
    final analysis = AnalysisService(
      store: store,
      settings: settings,
      session: session,
      planner: AnalysisPlanner(store, clock),
      worker: worker,
      clock: clock,
    );
    await analysis.initialize(runTimer: false);
    final ticking = analysis.tick();
    await Future<void>.delayed(Duration.zero);
    await settings.update(settings.value.copy(language: 'ja'));
    expect(provider.cancellations, 0);
    pending.complete(const AnalysisResult(matched: false, findings: []));
    await ticking;
    await Future<void>.delayed(Duration.zero);
    expect(store.queue.values.single.phase, JobPhase.succeeded);
    await analysis.close();
    await session.close();
    await settings.close();
    await engine.dispose();
    await store.close();
  });
}
