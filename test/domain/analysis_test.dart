import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vox_local/domain/analysis.dart';
import 'package:vox_local/domain/failure.dart';
import 'package:vox_local/domain/models.dart';

import '../fakes.dart';

void main() {
  group('retry policy', () {
    const policy = RetryPolicy();
    test('429 honors longer Retry-After', () {
      final d = policy.decide(
        const AppFailure(
          FailureKind.rateLimited,
          'fixture',
          retryAfter: Duration(seconds: 10),
        ),
        1,
        .5,
      );
      expect(d.phase, JobPhase.retrying);
      expect(d.delay, const Duration(seconds: 10));
    });
    test(
      'authentication blocks rather than loops',
      () => expect(
        policy
            .decide(const AppFailure(FailureKind.credentials, 'fixture'), 1, .5)
            .phase,
        JobPhase.blocked,
      ),
    );
    test(
      'balance blocks rather than loops',
      () => expect(
        policy
            .decide(const AppFailure(FailureKind.balance, 'fixture'), 1, .5)
            .phase,
        JobPhase.blocked,
      ),
    );
    test(
      'invalid response is bounded',
      () => expect(
        policy
            .decide(
              const AppFailure(FailureKind.invalidResponse, 'fixture'),
              1,
              .5,
            )
            .phase,
        JobPhase.failed,
      ),
    );
    test(
      'stops at maximum attempts',
      () => expect(
        policy
            .decide(const AppFailure(FailureKind.server, 'fixture'), 4, .5)
            .phase,
        JobPhase.failed,
      ),
    );
    test(
      'backoff grows predictably',
      () => expect(
        policy
            .decide(const AppFailure(FailureKind.server, 'fixture'), 3, .5)
            .delay,
        const Duration(seconds: 8),
      ),
    );
  });
  group('planner', () {
    late MemoryStore store;
    late FakeClock clock;
    late AnalysisPlanner planner;
    setUp(() {
      store = MemoryStore();
      clock = FakeClock();
      planner = AnalysisPlanner(store, clock);
    });
    tearDown(() => store.close());
    test(
      'no text does not enqueue',
      () async => expect(
        await planner.plan('session', profile, AnalysisTemplate.presets.first),
        false,
      ),
    );
    test('does not schedule same text twice', () async {
      await store.appendSegment(segment(1));
      expect(
        await planner.plan('session', profile, AnalysisTemplate.presets.first),
        true,
      );
      expect(
        await planner.plan('session', profile, AnalysisTemplate.presets.first),
        false,
      );
      expect(store.queue.length, 1);
    });
    test('new rule version gets independent coverage', () async {
      await store.appendSegment(segment(1));
      final template = AnalysisTemplate.presets.first;
      await planner.plan('session', profile, template);
      await planner.plan('session', profile, template.copyWith(version: 2));
      expect(store.queue.length, 2);
    });
    test('batches respect input budget without losing coverage', () async {
      for (var i = 1; i <= 8; i++) {
        await store.appendSegment(
          segment(i, text: List.filled(1500, '字').join()),
        );
      }
      final p = profile.copyWith(inputCharacters: 6000);
      while (await planner.plan(
        'session',
        p,
        AnalysisTemplate.presets.first,
      )) {}
      final seq = store.queue.values
          .expand((j) => j.segments)
          .map((s) => s.sequence)
          .toList();
      expect(seq, List.generate(8, (i) => i + 1));
    });
    test('context is bounded and is not reclassified as new text', () async {
      await store.appendSegment(
        segment(1, text: List.filled(1200, '前').join()),
      );
      await planner.plan('session', profile, AnalysisTemplate.presets.first);
      await store.appendSegment(segment(2));
      await planner.plan('session', profile, AnalysisTemplate.presets.first);
      final second = store.queue.values.last;
      expect(second.context.length, 1000);
      expect(second.segments.single.sequence, 2);
    });
    test('output language is captured in the job snapshot', () async {
      await store.appendSegment(segment(1));
      await planner.plan(
        'session',
        profile,
        AnalysisTemplate.presets.first,
        language: 'en',
      );
      expect(store.queue.values.single.language, 'en');
      expect(job().language, 'zh');
    });
    test('concurrent plans do not duplicate coverage', () async {
      await store.appendSegment(segment(1));
      final results = await Future.wait([
        planner.plan('session', profile, AnalysisTemplate.presets.first),
        planner.plan('session', profile, AnalysisTemplate.presets.first),
      ]);
      expect(results.where((v) => v).length, 1);
    });
  });
  group('worker isolation', () {
    late MemoryStore store;
    late FakeClock clock;
    late FakeCredentials credentials;
    late FakeProvider provider;
    late AnalysisWorker worker;
    setUp(() {
      store = MemoryStore();
      clock = FakeClock();
      credentials = FakeCredentials()
        ..values[profile.credentialRef] = 'synthetic-fixture';
      provider = FakeProvider();
      worker = AnalysisWorker(
        store: store,
        credentials: credentials,
        provider: provider,
        clock: clock,
        random: FixedRandom(),
      );
      store.queue['job'] = job();
    });
    tearDown(() => store.close());
    test('persists success once', () async {
      await worker.tick();
      await worker.tick();
      expect(provider.calls, 1);
      expect(store.queue['job']!.phase, JobPhase.succeeded);
    });
    test('does not retry before scheduled time', () async {
      provider.handler = (_) async => throw const AppFailure(
        FailureKind.rateLimited,
        'fixture',
        retryAfter: Duration(seconds: 10),
      );
      await worker.tick();
      clock.advance(const Duration(seconds: 9));
      await worker.tick();
      expect(provider.calls, 1);
      clock.advance(const Duration(seconds: 1));
      provider.handler = null;
      await worker.tick();
      expect(provider.calls, 2);
      expect(store.queue['job']!.phase, JobPhase.succeeded);
    });
    test('missing credentials blocks without calling provider', () async {
      credentials.values.clear();
      await worker.tick();
      expect(provider.calls, 0);
      expect(store.queue['job']!.phase, JobPhase.blocked);
    });
    test('logging failure cannot turn success into failure', () async {
      store.logFailure = true;
      await worker.tick();
      expect(store.queue['job']!.phase, JobPhase.succeeded);
    });
    test('concurrent ticks execute only one request', () async {
      final complete = Completer<AnalysisResult>();
      provider.handler = (_) => complete.future;
      final first = worker.tick();
      await Future<void>.delayed(Duration.zero);
      await worker.tick();
      expect(provider.calls, 1);
      complete.complete(const AnalysisResult(matched: false, findings: []));
      await first;
    });
    test(
      'pause preserves unfinished coverage and ignores late result',
      () async {
        final complete = Completer<AnalysisResult>();
        provider.handler = (_) => complete.future;
        final first = worker.tick();
        await Future<void>.delayed(Duration.zero);
        worker.pause();
        complete.complete(const AnalysisResult(matched: false, findings: []));
        await first;
        expect(store.queue['job']!.phase, JobPhase.retrying);
      },
    );
    test('storage commit failure does not claim success', () async {
      store.writeFailure = true;
      await worker.tick();
      expect(store.queue['job']!.phase, JobPhase.running);
      store.writeFailure = false;
      await store.recover();
      expect(store.queue['job']!.phase, JobPhase.retrying);
    });
    test('diagnostics never include credential or transcript', () async {
      await worker.tick();
      final encoded = jsonEncode(store.entries.map((e) => e.toJson()).toList());
      expect(encoded, isNot(contains('synthetic-fixture')));
      expect(encoded, isNot(contains('合成测试文本')));
    });
  });
  group('result contract', () {
    const validator = ResultValidator();
    test(
      'no match is success',
      () => expect(
        validator.parse('{"matched":false,"findings":[]}', job()).matched,
        false,
      ),
    );
    test(
      'unknown evidence is rejected',
      () => expect(
        () => validator.parse(
          '{"matched":true,"findings":[{"topic":"预算","summary":"合成发现","evidenceSegmentIds":["unknown"]}]}',
          job(),
        ),
        throwsA(isA<AppFailure>()),
      ),
    );
    test(
      'matched without findings is rejected',
      () => expect(
        () => validator.parse('{"matched":true,"findings":[]}', job()),
        throwsA(isA<AppFailure>()),
      ),
    );
    test(
      'malformed response is rejected',
      () => expect(
        () => validator.parse('not json', job()),
        throwsA(isA<AppFailure>()),
      ),
    );
    test('generated serialization roundtrips job snapshot', () {
      final original = job();
      expect(
        AnalysisJob.fromJson(jsonDecode(jsonEncode(original.toJson()))),
        original,
      );
    });
    test(
      'generated collections are immutable',
      () =>
          expect(() => job().segments.add(segment(2)), throwsUnsupportedError),
    );
    test(
      'unsafe provider address rejected',
      () => expect(
        () => profile.copyWith(endpoint: 'http://example.invalid').validate(),
        throwsFormatException,
      ),
    );
  });
}
