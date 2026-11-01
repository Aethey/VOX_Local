import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vox_local/application/providers.dart';
import 'package:vox_local/application/session_service.dart';
import 'package:vox_local/domain/models.dart';
import 'package:vox_local/l10n/localization.dart';
import 'package:vox_local/main.dart';

import '../fakes.dart';
import 'app_test.dart' show fixture, openRecordScreen;

List<TranscriptSegment> paragraphs(int count) => List.generate(
  count,
  (i) => segment(
    i + 1,
    text:
        '第 ${i + 1} 段：这里是一段用于检查长文本排版的会话。This is a readable transcript. 日本語の会話も確認します。',
  ),
);

void main() {
  testWidgets(
    'reduced motion keeps recording feedback without a repeating animation',
    (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      final runtime = await fixture();
      runtime.session.emit(
        SessionState(
          id: 'session',
          phase: SessionPhase.recording,
          startedAt: runtime.clock.now(),
          segments: paragraphs(3),
        ),
      );
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
        expect(
          find.byKey(const ValueKey('recording-waveform')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('recording-duration')),
          findsOneWidget,
        );
        expect(tester.binding.transientCallbackCount, 0);
        expect(tester.takeException(), isNull);
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.runAsync(runtime.dispose);
      }
    },
  );
  for (final locale in ['zh', 'ja', 'en']) {
    testWidgets(
      '$locale recording remains compact with long text and large font',
      (tester) async {
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 1.6;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final runtime = await fixture(uiLocale: locale);
        await runtime.models.prepare('turbo', sessionActive: false);
        final strings = await AppLocalizations.delegate.load(Locale(locale));
        runtime.session.emit(
          SessionState(
            id: 'session',
            phase: SessionPhase.recording,
            startedAt: runtime.clock.now(),
            segments: paragraphs(40),
          ),
        );
        try {
          await tester.pumpWidget(
            ProviderScope(
              overrides: [runtimeProvider.overrideWithValue(runtime)],
              child: const VoxApp(),
            ),
          );
          await tester.pump(const Duration(milliseconds: 300));
          await openRecordScreen(tester);
          expect(
            find.byKey(const ValueKey('recording-waveform')),
            findsOneWidget,
          );
          expect(find.byTooltip(strings.stopRecording), findsOneWidget);
          expect(
            tester.getSize(find.byKey(const ValueKey('recording-dock'))).height,
            lessThanOrEqualTo(80),
          );
          expect(
            tester
                .getSize(find.byKey(const ValueKey('transcript-scroll')))
                .height,
            greaterThan(640 * .55),
          );
          expect(tester.binding.transientCallbackCount, greaterThan(0));
          var changes = 0;
          final sub = runtime.session.changes.listen((_) => changes++);
          (runtime.clock as FakeClock).advance(const Duration(seconds: 5));
          runtime.session.level.emit(.8);
          await tester.pump(const Duration(seconds: 1));
          expect(
            tester
                .widget<Text>(find.byKey(const ValueKey('recording-duration')))
                .data,
            '00:05',
          );
          expect(
            changes,
            0,
            reason:
                'clock and waveform must not update session/transcript state',
          );
          await tester.runAsync(sub.cancel);
          runtime.session.emit(
            runtime.session.value.copy(phase: SessionPhase.completed),
          );
          await tester.pumpAndSettle();
          expect(
            find.byKey(const ValueKey('recording-waveform')),
            findsNothing,
          );
          expect(find.byTooltip(strings.startNewRecording), findsOneWidget);
          expect(tester.takeException(), isNull);
        } finally {
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.runAsync(runtime.dispose);
        }
      },
    );
  }

  testWidgets(
    'new content follows the tail without interrupting history reading',
    (tester) async {
      final runtime = await fixture();
      runtime.session.emit(
        SessionState(
          id: 'session',
          phase: SessionPhase.recording,
          startedAt: runtime.clock.now(),
          segments: paragraphs(40),
        ),
      );
      try {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [runtimeProvider.overrideWithValue(runtime)],
            child: const VoxApp(),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));
        await openRecordScreen(tester);
        await tester.pump(const Duration(milliseconds: 300));
        final scroll = find.byKey(const ValueKey('transcript-scroll'));
        final position = tester
            .state<ScrollableState>(
              find
                  .descendant(of: scroll, matching: find.byType(Scrollable))
                  .first,
            )
            .position;
        expect(position.extentAfter, lessThan(1));
        await tester.drag(scroll, const Offset(0, 350));
        await tester.pump(const Duration(milliseconds: 300));
        final historyOffset = position.pixels;
        expect(position.extentAfter, greaterThan(72));
        runtime.session.emit(
          runtime.session.value.copy(segments: paragraphs(41)),
        );
        await tester.pump(const Duration(milliseconds: 300));
        expect(position.pixels, closeTo(historyOffset, 1));
        await tester.tap(find.byTooltip('跳到最新文字'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump();
        expect(position.extentAfter, lessThan(1));
        runtime.session.emit(
          runtime.session.value.copy(segments: paragraphs(42)),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump();
        expect(position.extentAfter, lessThan(1));
        expect(tester.takeException(), isNull);
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.runAsync(runtime.dispose);
      }
    },
  );
}
