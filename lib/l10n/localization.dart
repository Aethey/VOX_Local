import 'package:flutter/widgets.dart';

import '../domain/models.dart';
import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

extension LocalizedContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension LocalizedTemplates on AppLocalizations {
  String templateNameFor(AnalysisTemplate template) => !template.preset
      ? template.name
      : switch (template.id) {
          'actions' => presetActions,
          'decisions' => presetDecisions,
          'risks' => presetRisks,
          _ => template.name,
        };

  String templateRulesFor(AnalysisTemplate template) => !template.preset
      ? template.instruction
      : switch (template.id) {
          'actions' => presetActionsRules,
          'decisions' => presetDecisionsRules,
          'risks' => presetRisksRules,
          _ => template.instruction,
        };
}
