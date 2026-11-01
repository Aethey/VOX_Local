import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vox_local/application/analysis_service.dart';
import 'package:vox_local/application/model_service.dart';
import 'package:vox_local/application/providers.dart';
import 'package:vox_local/application/runtime.dart';
import 'package:vox_local/application/session_service.dart';
import 'package:vox_local/application/settings_service.dart';
import 'package:vox_local/domain/analysis.dart';
import 'package:vox_local/domain/models.dart';
import 'package:vox_local/main.dart';

import '../fakes.dart';

Future<AppRuntime> fixture({String uiLocale = 'zh'}) async {
  final store = MemoryStore();
  final keys = FakeCredentials();
  final engine = FakeSpeech();
  final clock = FakeClock();
  final settings = SettingsService(store, keys);
  await settings.update(settings.value.copy(uiLocale: uiLocale));
  final session = SessionService(engine, store, clock, FixedRandom());
  final models = ModelService(engine, store, clock);
  final analysis = AnalysisService(
    store: store,
    settings: settings,
    session: session,
    planner: AnalysisPlanner(store, clock),
    worker: AnalysisWorker(
      store: store,
      credentials: keys,
      provider: FakeProvider(),
      clock: clock,
      random: FixedRandom(),
    ),
    clock: clock,
  );
  return AppRuntime(
    store: store,
    credentials: keys,
    engine: engine,
    clock: clock,
    settings: settings,
    models: models,
    session: session,
    analysis: analysis,
  );
}

/// Home is the recording library. The capture UI lives on the record route:
/// the primary button starts a new recording, the floating button returns to
/// one that is still running. Uses bounded pumps because a live recording
/// keeps an animation running.
Future<void> openRecordScreen(WidgetTester tester) async {
  final floating = find.byKey(const ValueKey('active-recording'));
  final button = floating.evaluate().isNotEmpty
      ? floating
      : find.byType(FilledButton).first;
  await tester.ensureVisible(button);
  await tester.pump();
  await tester.tap(button);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump();
}

void main() {
  testWidgets('starts on the library and navigates via generated routes', (
    tester,
  ) async {
    final runtime = await fixture();
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await runtime.dispose();
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [runtimeProvider.overrideWithValue(runtime)],
        child: const VoxApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('暂无录音记录'), findsOneWidget);
    await openRecordScreen(tester);
    await tester.pumpAndSettle();
    expect(find.byTooltip('选择并下载离线模型'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('record-action')));
    await tester.pumpAndSettle();
    expect(find.text('Large V3 Turbo'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('暂无录音记录'), findsOneWidget);
    await tester.tap(find.text('设置'));
    await tester.pumpAndSettle();
    expect(find.text('识别语言'), findsOneWidget);
    await tester.tap(find.text('离线模型'));
    await tester.pumpAndSettle();
    expect(find.text('Large V3 Turbo'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('small screen and large text do not overflow', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final runtime = await fixture();
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await runtime.dispose();
    });
    // A saved recording without an analysis profile exercises the setup path.
    await runtime.store.saveRecording(
      RecordingSummary(
        id: 'saved',
        createdAt: runtime.clock.now(),
        updatedAt: runtime.clock.now(),
        title: '合成记录',
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [runtimeProvider.overrideWithValue(runtime)],
        child: const VoxApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('合成记录'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('分析'));
    await tester.pumpAndSettle();
    expect(find.text('在线分析'), findsOneWidget);
    await tester.tap(find.text('配置分析提供商'));
    await tester.pumpAndSettle();
    expect(find.text('API 密钥'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('icon action starts and stops recording', (tester) async {
    final runtime = await fixture();
    await runtime.models.prepare('turbo', sessionActive: false);
    try {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [runtimeProvider.overrideWithValue(runtime)],
          child: const VoxApp(),
        ),
      );
      await tester.pumpAndSettle();
      await openRecordScreen(tester);
      await tester.pumpAndSettle();
      expect(find.byTooltip('开始录音'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('record-action')));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byTooltip('结束录音'), findsOneWidget);
      final engine = runtime.engine as FakeSpeech;
      expect(engine.starts, 1);
      await tester.tap(find.byKey(const ValueKey('record-action')));
      await tester.pumpAndSettle();
      expect(engine.stops, 1);
      // The finished recording is shown read-only with a shortcut to a new one.
      expect(find.byTooltip('新录音'), findsOneWidget);
      expect(runtime.session.value.record?.status, RecordingStatus.completed);
      expect(tester.takeException(), isNull);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(runtime.dispose);
    }
  });
  testWidgets('floating button returns to the running recording', (
    tester,
  ) async {
    final runtime = await fixture();
    await runtime.models.prepare('turbo', sessionActive: false);
    try {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [runtimeProvider.overrideWithValue(runtime)],
          child: const VoxApp(),
        ),
      );
      await tester.pumpAndSettle();
      // Idle: no floating button anywhere.
      expect(find.byKey(const ValueKey('active-recording')), findsNothing);
      await openRecordScreen(tester);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('record-action')));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byKey(const ValueKey('active-recording')), findsNothing);
      // Leave the record screen; capture keeps running.
      await tester.tap(find.byType(BackButton));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byKey(const ValueKey('active-recording')), findsOneWidget);
      expect(find.text('新录音'), findsNothing);
      await tester.tap(find.text('设置'));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byKey(const ValueKey('active-recording')), findsOneWidget);
      await tester.tap(find.text('离线模型'));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byKey(const ValueKey('active-recording')), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('active-recording')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();
      expect(find.byTooltip('结束录音'), findsOneWidget);
      expect(find.byKey(const ValueKey('active-recording')), findsNothing);
      await tester.tap(find.byKey(const ValueKey('record-action')));
      await tester.pumpAndSettle();
      expect((runtime.engine as FakeSpeech).stops, 1);
      expect(tester.takeException(), isNull);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(runtime.dispose);
    }
  });
  testWidgets('a saved recording can be resumed from the library menu', (
    tester,
  ) async {
    final runtime = await fixture();
    await runtime.models.prepare('turbo', sessionActive: false);
    await runtime.store.saveRecording(
      RecordingSummary(
        id: 'saved',
        createdAt: runtime.clock.now(),
        updatedAt: runtime.clock.now(),
        title: '合成记录',
        duration: 12,
      ),
    );
    await runtime.store.appendSegment(segment(1, sessionId: 'saved'));
    try {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [runtimeProvider.overrideWithValue(runtime)],
          child: const VoxApp(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('记录操作'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('继续录音'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();
      final engine = runtime.engine as FakeSpeech;
      expect(engine.starts, 1);
      expect(engine.lastId, 'saved');
      expect(engine.lastAfterSequence, 1);
      expect(engine.lastOffset, 2.0);
      // The record screen shows the stored text and the live stop control.
      expect(find.text('合成测试文本 1'), findsOneWidget);
      expect(find.byTooltip('结束录音'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('record-action')));
      await tester.pumpAndSettle();
      expect(engine.stops, 1);
      expect(
        (await runtime.store.recording('saved'))!.status,
        RecordingStatus.completed,
      );
      expect(tester.takeException(), isNull);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(runtime.dispose);
    }
  });
  testWidgets('a finished recording can be re-analyzed as a whole', (
    tester,
  ) async {
    final runtime = await fixture();
    await runtime.settings.saveProfile(profile, 'synthetic-fixture');
    await runtime.store.saveRecording(
      RecordingSummary(
        id: 'saved',
        createdAt: runtime.clock.now(),
        updatedAt: runtime.clock.now(),
        title: '合成记录',
      ),
    );
    await runtime.store.appendSegment(segment(1, sessionId: 'saved'));
    await runtime.store.appendSegment(segment(2, sessionId: 'saved'));
    // The app starts this listener; without it a finished job never reaches
    // the screen. No timer, so pumpAndSettle can settle.
    await runtime.analysis.initialize(runTimer: false);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await runtime.dispose();
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [runtimeProvider.overrideWithValue(runtime)],
        child: const VoxApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('合成记录'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('分析'));
    await tester.pumpAndSettle();
    final button = find.byKey(const ValueKey('analyze-whole'));
    expect(
      find.descendant(of: button, matching: find.text('整体重新分析')),
      findsOneWidget,
    );
    await tester.tap(button);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    final jobs = (runtime.store as MemoryStore).queue.values.toList();
    expect(jobs, hasLength(1));
    expect(jobs.single.whole, isTrue);
    expect(jobs.single.segments, hasLength(2));
    expect(jobs.single.phase, JobPhase.succeeded);
    for (var i = 0; i < 10 && find.text('整体分析').evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    if (find.text('整体分析').evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        find.text('整体分析'),
        300,
        scrollable: find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Scrollable),
        ),
      );
    }
    expect(find.text('整体分析'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('provider configuration can be cleared after confirmation', (
    tester,
  ) async {
    final runtime = await fixture();
    await runtime.settings.saveProfile(profile, 'synthetic-fixture');
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await runtime.dispose();
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [runtimeProvider.overrideWithValue(runtime)],
        child: const VoxApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('设置'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('提供商与模型'));
    await tester.pumpAndSettle();
    final clear = find.byKey(const ValueKey('clear-provider'));
    await tester.scrollUntilVisible(
      clear,
      200,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(clear);
    await tester.pumpAndSettle();
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(runtime.settings.value.profile, isNotNull);
    await tester.tap(clear);
    await tester.pumpAndSettle();
    await tester.tap(find.text('清除配置').last);
    await tester.pumpAndSettle();
    expect(runtime.settings.value.profile, isNull);
    expect((runtime.credentials as FakeCredentials).values, isEmpty);
    expect(find.text('已清除提供商配置'), findsOneWidget);
    expect(find.text('尚未配置'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('controller dependencies can be overridden independently', (
    tester,
  ) async {
    final runtime = await fixture();
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await runtime.dispose();
    });
    final container = ProviderContainer.test(
      overrides: [runtimeProvider.overrideWithValue(runtime)],
    );
    final before = container.read(sessionProvider);
    await runtime.settings.update(runtime.settings.value.copy(interval: 60));
    expect(container.read(settingsProvider).interval, 60);
    expect(container.read(sessionProvider), same(before));
  });
}
