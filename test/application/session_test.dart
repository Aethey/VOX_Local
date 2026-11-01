import 'package:flutter_test/flutter_test.dart';
import 'package:vox_local/application/session_service.dart';
import 'package:vox_local/application/settings_service.dart';
import 'package:vox_local/domain/models.dart';
import 'package:vox_local/domain/speech.dart';

import '../fakes.dart';

void main() {
  late MemoryStore store;
  late FakeSpeech engine;
  late SessionService session;
  setUp(() {
    store = MemoryStore();
    engine = FakeSpeech();
    session = SessionService(engine, store, FakeClock(), FixedRandom());
  });
  tearDown(() async {
    await session.close();
    await engine.dispose();
    await store.close();
  });
  test('model readiness guards microphone', () async {
    await session.start(ready: false, language: 'zh');
    expect(engine.starts, 0);
    expect(session.value.error, isNotNull);
  });
  test('duplicate starts are ignored', () async {
    await session.start(ready: true, language: 'zh');
    await session.start(ready: true, language: 'zh');
    expect(engine.starts, 1);
  });
  test('native duplicate segments are persisted and shown once', () async {
    await session.start(ready: true, language: 'zh');
    final s = segment(1, sessionId: engine.lastId!);
    engine.source.add(
      SpeechEvent('segment', sessionId: engine.lastId, segment: s),
    );
    engine.source.add(
      SpeechEvent('segment', sessionId: engine.lastId, segment: s),
    );
    await session.stop();
    expect(session.value.segments.length, 1);
    expect(store.transcript.length, 1);
  });
  test('decoder tokens never enter display, storage or dictation', () async {
    await session.start(ready: true, language: 'zh');
    engine.source.add(
      SpeechEvent(
        'partial',
        sessionId: engine.lastId,
        text:
            '<|startoftranscript|><|zh|><|transcribe|><|0.00|>能听见我说话吗<|2.82|>',
      ),
    );
    expect(session.value.partial, '能听见我说话吗');
    engine.source.add(
      SpeechEvent(
        'segment',
        sessionId: engine.lastId,
        segment: segment(
          1,
          sessionId: engine.lastId!,
          text: '<|0.00|>能听见我说话吗<|2.82|><|endoftext|>',
        ),
      ),
    );
    await session.stop();
    expect(session.value.segments.single.text, '能听见我说话吗');
    expect(store.transcript.values.single.text, '能听见我说话吗');
    await session.start(ready: true, language: 'zh', dictation: true);
    engine.source.add(
      SpeechEvent(
        'segment',
        sessionId: engine.lastId,
        segment: segment(
          1,
          sessionId: engine.lastId!,
          text: '<|zh|>预算<|endoftext|>',
        ),
      ),
    );
    await session.stop();
    expect(session.value.draft, '预算');
  });
  test('late event from another session is ignored', () async {
    await session.start(ready: true, language: 'zh');
    engine.source.add(
      SpeechEvent('segment', sessionId: 'stale', segment: segment(1)),
    );
    await session.stop();
    expect(store.transcript, isEmpty);
  });
  test('dictation does not pollute conversation', () async {
    await session.start(ready: true, language: 'zh', dictation: true);
    engine.source.add(
      SpeechEvent(
        'segment',
        sessionId: engine.lastId,
        segment: segment(1, sessionId: engine.lastId!),
      ),
    );
    await session.stop();
    expect(store.transcript, isEmpty);
    expect(session.value.draft, isNotEmpty);
  });
  test('engine start failure restores previous state', () async {
    engine.failStart = true;
    await session.start(ready: true, language: 'zh');
    expect(session.value.phase, SessionPhase.idle);
    expect(session.value.error, isNotNull);
  });
  test('resuming a record continues numbering and timeline', () async {
    final clock = FakeClock();
    await session.close();
    session = SessionService(engine, store, clock, FixedRandom());
    await session.start(ready: true, language: 'zh');
    final id = engine.lastId!;
    engine.source.add(
      SpeechEvent(
        'segment',
        sessionId: id,
        segment: segment(1, sessionId: id),
      ),
    );
    clock.advance(const Duration(seconds: 5));
    await session.stop();
    expect(session.value.record!.status, RecordingStatus.completed);
    await session.newRecording();

    await session.resume(id: id, ready: true, language: 'ja', model: 'small');
    expect(engine.starts, 2);
    expect(engine.lastAfterSequence, 1);
    expect(engine.lastOffset, 2.0);
    expect(session.value.phase, SessionPhase.recording);
    expect(session.value.id, id);
    expect(session.value.segments.length, 1);
    expect(session.value.record!.status, RecordingStatus.recording);
    expect(session.value.record!.analysisEnabled, isFalse);
    expect((await store.recording(id))!.status, RecordingStatus.recording);

    // A duplicate of the stored segment is rejected; a following one lands.
    engine.source.add(
      SpeechEvent(
        'segment',
        sessionId: id,
        segment: segment(1, sessionId: id),
      ),
    );
    engine.source.add(
      SpeechEvent(
        'segment',
        sessionId: id,
        segment: segment(2, sessionId: id),
      ),
    );
    clock.advance(const Duration(seconds: 4));
    await session.stop();
    expect(session.value.segments.map((s) => s.sequence), [1, 2]);
    expect(store.transcript.length, 2);
    final finished = (await store.recording(id))!;
    expect(finished.status, RecordingStatus.completed);
    expect(finished.duration, 9.0);
    expect(finished.language, 'ja');
  });
  test('resume is refused while capturing or without a model', () async {
    await session.start(ready: true, language: 'zh');
    final first = engine.lastId!;
    engine.source.add(
      SpeechEvent(
        'segment',
        sessionId: first,
        segment: segment(1, sessionId: first),
      ),
    );
    await expectLater(
      session.resume(id: first, ready: true, language: 'zh'),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          'finishRecordingFirst',
        ),
      ),
    );
    await session.stop();
    await expectLater(
      session.resume(id: first, ready: false, language: 'zh'),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          'downloadModelFirst',
        ),
      ),
    );
    await expectLater(
      session.resume(id: 'missing', ready: true, language: 'zh'),
      throwsA(isA<FormatException>()),
    );
    expect(engine.starts, 1);
    expect(session.value.active, isFalse);
  });
  test('failed resume restores the stored status', () async {
    await session.start(ready: true, language: 'zh');
    final id = engine.lastId!;
    engine.source.add(
      SpeechEvent(
        'segment',
        sessionId: id,
        segment: segment(1, sessionId: id),
      ),
    );
    await session.stop();
    await session.newRecording();
    engine.failStart = true;
    await expectLater(
      session.resume(id: id, ready: true, language: 'zh'),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          'speechStartFailed',
        ),
      ),
    );
    expect(session.value.active, isFalse);
    expect(session.value.id, isNull);
    expect((await store.recording(id))!.status, RecordingStatus.completed);
  });
  test('meter does not rebuild session state', () async {
    await session.start(ready: true, language: 'zh');
    var changes = 0;
    final sub = session.changes.listen((_) {
      changes++;
    });
    engine.source.add(
      SpeechEvent('level', sessionId: engine.lastId, level: .7),
    );
    expect(changes, 0);
    expect(session.level.value, .7);
    await sub.cancel();
  });
  test('saving config stores key only in credential adapter', () async {
    final keys = FakeCredentials();
    final settings = SettingsService(store, keys);
    await settings.saveProfile(profile, 'synthetic-fixture');
    expect(
      (await store.setting('settings'))!,
      isNot(contains('synthetic-fixture')),
    );
    expect(keys.values[profile.credentialRef], 'synthetic-fixture');
  });
  test(
    'clearing the provider removes the credential and the profile',
    () async {
      final keys = FakeCredentials();
      final settings = SettingsService(store, keys);
      await settings.saveProfile(profile, 'synthetic-fixture');
      await settings.update(settings.value.copy(analysisEnabled: true));
      await settings.clearProfile();
      expect(keys.values, isEmpty);
      expect(settings.value.profile, isNull);
      expect(settings.value.analysisEnabled, isFalse);
      final restored = SettingsService(store, keys);
      await restored.restore();
      expect(restored.value.profile, isNull);
      await restored.close();
      await settings.close();
    },
  );
  test('analysis language is validated and persisted', () async {
    final settings = SettingsService(store, FakeCredentials());
    await expectLater(
      settings.update(settings.value.copy(analysisLanguage: 'fr')),
      throwsFormatException,
    );
    await settings.update(settings.value.copy(analysisLanguage: 'ja'));
    expect(settings.value.analysisLanguage, 'ja');
    expect(SettingsState.fromJson({}).analysisLanguage, 'zh');
    await settings.close();
  });
  test('failed setting write does not emit success', () async {
    final settings = SettingsService(store, FakeCredentials());
    store.writeFailure = true;
    await expectLater(
      settings.update(settings.value.copy(interval: 60)),
      throwsStateError,
    );
    expect(settings.value.interval, 30);
    await settings.close();
  });
}
