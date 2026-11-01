import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vox_local/application/providers.dart';
import 'package:vox_local/application/session_service.dart';
import 'package:vox_local/application/settings_service.dart';
import 'package:vox_local/domain/models.dart';
import 'package:vox_local/l10n/localization.dart';
import 'package:vox_local/main.dart';

import 'app_test.dart' show fixture, openRecordScreen;

void main() {
  test('all ARB locales have matching keys and placeholders', () {
    final template = jsonDecode(
      File('lib/l10n/app_en.arb').readAsStringSync(),
    ) as Map<String, dynamic>;
    final keys = template.keys.where((key) => !key.startsWith('@')).toSet();
    for (final locale in ['en', 'zh', 'ja']) {
      final catalog = jsonDecode(
        File('lib/l10n/app_$locale.arb').readAsStringSync(),
      ) as Map<String, dynamic>;
      expect(catalog.keys.where((key) => !key.startsWith('@')).toSet(), keys);
      for (final key in keys) {
        expect(catalog[key], isNotEmpty, reason: '$locale/$key');
        expect(
          catalog['@$key'],
          template['@$key'],
          reason: '$locale/$key metadata',
        );
      }
    }
  });

  test(
    'generated messages cover every error code in all three languages',
    () async {
      final catalog = jsonDecode(
        File('lib/l10n/app_en.arb').readAsStringSync(),
      );
      final codes = RegExp(r'(\w+) \{')
          .allMatches(catalog['message'] as String)
          .map((match) => match[1]!)
          .where((code) => code != 'other' && code != 'operationFailed');
      for (final locale in AppLocalizations.supportedLocales) {
        final strings = await AppLocalizations.delegate.load(locale);
        for (final code in codes) {
          expect(
            strings.message(code),
            isNot(strings.message('unknown')),
            reason: '${locale.languageCode}/$code',
          );
        }
      }
    },
  );

  for (final locale in ['ja', 'zh', 'en']) {
    testWidgets('$locale localizes navigation, failures and preset templates', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.6;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final runtime = await fixture(uiLocale: locale);
      final strings = await AppLocalizations.delegate.load(Locale(locale));
      try {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [runtimeProvider.overrideWithValue(runtime)],
            child: const VoxApp(),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(strings.noRecordings), findsOneWidget);
        await openRecordScreen(tester);
        await tester.pumpAndSettle();
        expect(find.byTooltip(strings.chooseDownloadModel), findsOneWidget);
        // Opening a new recording resets state, so inject the failure here.
        runtime.session.emit(const SessionState(error: 'speechStartFailed'));
        await tester.pumpAndSettle();
        expect(find.text(strings.message('speechStartFailed')), findsOneWidget);
        await tester.tap(find.text(strings.analysis));
        await tester.pumpAndSettle();
        expect(find.text(strings.recordBeforeAnalysis), findsOneWidget);
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        await tester.tap(find.text(strings.settings));
        await tester.pumpAndSettle();
        expect(find.text(strings.appLanguage), findsOneWidget);
        // Preset template names are shown through l10n, not the stored name.
        await tester.scrollUntilVisible(
          find.text(strings.presetActions),
          100,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text(strings.presetActions), findsOneWidget);
        expect(tester.takeException(), isNull);
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.runAsync(runtime.dispose);
      }
    });
  }

  testWidgets('language picker persists independently of speech language', (
    tester,
  ) async {
    final runtime = await fixture();
    try {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [runtimeProvider.overrideWithValue(runtime)],
          child: const VoxApp(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('设置'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('app-language')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('English').last);
      await tester.pumpAndSettle();
      expect(find.text('App language'), findsOneWidget);
      expect(runtime.settings.value.uiLocale, 'en');
      expect(runtime.settings.value.language, 'zh');
      final restored = SettingsService(runtime.store, runtime.credentials);
      await restored.restore();
      expect(restored.value.uiLocale, 'en');
      await restored.close();
      expect(SettingsState.fromJson({}).uiLocale, 'system');
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(runtime.dispose);
    }
  });

  testWidgets(
    'system locale resolves Japanese and unsupported locales fall back to English',
    (tester) async {
      final runtime = await fixture(uiLocale: 'system');
      tester.platformDispatcher.localesTestValue = [const Locale('ja', 'JP')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
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
        expect(find.byTooltip('オフラインモデルを選んでダウンロード'), findsOneWidget);
        tester.platformDispatcher.localesTestValue = [const Locale('fr', 'FR')];
        await tester.pumpAndSettle();
        expect(
          find.byTooltip('Choose & download an offline model'),
          findsOneWidget,
        );
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.runAsync(runtime.dispose);
      }
    },
  );

  testWidgets(
    'deleting a ready model requires confirmation and keeps the transcript',
    (tester) async {
      final runtime = await fixture(uiLocale: 'en');
      await runtime.models.prepare('turbo', sessionActive: false);
      const retained = TranscriptSegment(
        id: 'saved:1',
        sessionId: 'saved',
        sequence: 1,
        start: 0,
        end: 1,
        text: 'synthetic retained transcript',
      );
      await runtime.store.appendSegment(retained);
      try {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [runtimeProvider.overrideWithValue(runtime)],
            child: const VoxApp(),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Settings'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Offline models'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Delete model'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(runtime.models.readyId, 'turbo');
        await tester.tap(find.text('Delete model'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();
        expect(runtime.models.readyId, isNull);
        expect(runtime.models.value.first.installed, isFalse);
        expect(await runtime.store.segments('saved'), [retained]);
        expect(tester.takeException(), isNull);
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.runAsync(runtime.dispose);
      }
    },
  );
}
