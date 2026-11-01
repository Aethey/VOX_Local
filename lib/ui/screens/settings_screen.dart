import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../application/settings_service.dart';
import '../../l10n/localization.dart';
import '../routes.dart';
import '../widgets/common.dart';
import '../widgets/settings_group.dart';
import '../widgets/sheets.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _languageNames = {'zh': '中文', 'ja': '日本語', 'en': 'English'};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final models = ref.watch(modelProvider);
    final ready = models.any(
      (m) => m.id == settings.model && m.phase == 'ready',
    );
    Future<void> update(SettingsState next) => guardAction(
      context,
      () => ref.read(settingsProvider.notifier).update(next),
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        const SizedBox(height: 16),
        SettingsGroup(
          children: [
            ChoiceRow<String>(
              key: const ValueKey('app-language'),
              icon: Icons.translate_rounded,
              title: context.l10n.appLanguage,
              selected: settings.uiLocale,
              options: [
                ChoiceOption('system', context.l10n.systemLanguage),
                for (final entry in _languageNames.entries)
                  ChoiceOption(entry.key, entry.value),
              ],
              onChanged: (value) => update(settings.copy(uiLocale: value)),
            ),
          ],
        ),
        SectionTitle(context.l10n.localSpeech),
        SettingsGroup(
          children: [
            SettingsRow(
              icon: Icons.download_for_offline_outlined,
              title: context.l10n.offlineModels,
              subtitle: context.l10n.modelStatus(
                modelDisplayName(settings.model),
                ready ? context.l10n.ready : context.l10n.notReady,
              ),
              onTap: () => const ModelRoute().push(context),
            ),
            ChoiceRow<String>(
              icon: Icons.language_rounded,
              title: context.l10n.recognitionLanguage,
              selected: settings.language,
              options: [
                for (final entry in _languageNames.entries)
                  ChoiceOption(entry.key, entry.value),
                ChoiceOption('auto', context.l10n.autoDetect),
              ],
              onChanged: (value) => update(settings.copy(language: value)),
            ),
          ],
        ),
        SectionTitle(context.l10n.conversationAnalysis),
        SettingsGroup(
          children: [
            SettingsRow(
              icon: Icons.cloud_outlined,
              title: context.l10n.providerAndModel,
              subtitle: settings.profile?.model ?? context.l10n.notConfigured,
              onTap: () => const ProviderRoute().push(context),
            ),
            SettingsRow(
              icon: Icons.edit_note_rounded,
              title: context.l10n.analysisTemplates,
              subtitle: context.l10n.templateNameFor(settings.template),
              onTap: () => const TemplateRoute().push(context),
            ),
            ChoiceRow<String>(
              key: const ValueKey('analysis-language'),
              icon: Icons.translate_rounded,
              title: context.l10n.analysisLanguage,
              selected: settings.analysisLanguage,
              options: [
                for (final code in SettingsState.analysisLanguages)
                  ChoiceOption(code, _languageNames[code] ?? code),
              ],
              onChanged: (value) =>
                  update(settings.copy(analysisLanguage: value)),
            ),
            ChoiceRow<int>(
              icon: Icons.timer_outlined,
              title: context.l10n.analysisInterval,
              selected: settings.interval,
              options: [
                for (final n in const [10, 30, 60, 120, 300])
                  ChoiceOption(n, context.l10n.seconds(n)),
              ],
              onChanged: (value) => update(settings.copy(interval: value)),
            ),
          ],
        ),
        SectionTitle(context.l10n.runtimeStatus),
        SettingsGroup(
          children: [
            SettingsRow(
              icon: Icons.receipt_long_outlined,
              title: context.l10n.diagnostics,
              subtitle: context.l10n.diagnosticsSummary,
              onTap: () => const LogRoute().push(context),
            ),
          ],
        ),
        const SizedBox(height: 24),
        StatusNote(context.l10n.privacyNotice, icon: Icons.shield_outlined),
      ],
    );
  }
}
