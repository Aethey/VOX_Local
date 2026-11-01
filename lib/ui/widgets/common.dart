import 'package:flutter/material.dart';

import '../../domain/failure.dart';
import '../../l10n/localization.dart';

class StatusNote extends StatelessWidget {
  const StatusNote(
    this.text, {
    this.icon = Icons.info_outline_rounded,
    this.action,
    super.key,
  });
  final String text;
  final IconData icon;
  final Widget? action;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colors.onSecondaryContainer),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: colors.onSecondaryContainer),
            ),
          ),
          if (action != null)
            TextButtonTheme(
              data: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: colors.onSecondaryContainer,
                ),
              ),
              child: action!,
            ),
        ],
      ),
    );
  }
}

/// Audio → local transcript → optional analysis, without explanatory copy.
class ConversationFlow extends StatelessWidget {
  const ConversationFlow({this.analysis = false, super.key});
  final bool analysis;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    Widget step(IconData icon, String label, {bool selected = false}) =>
        Tooltip(
          message: label,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: selected ? colors.secondaryContainer : colors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 28,
              color: selected
                  ? colors.onSecondaryContainer
                  : colors.onSurfaceVariant,
            ),
          ),
        );
    return Semantics(
      label: context.l10n.flowDescription,
      child: ExcludeSemantics(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            step(
              Icons.mic_none_rounded,
              context.l10n.recordAudio,
              selected: !analysis,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: colors.onSurfaceVariant,
              ),
            ),
            step(Icons.subject_rounded, context.l10n.localText),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: colors.onSurfaceVariant,
              ),
            ),
            step(
              Icons.auto_awesome_outlined,
              context.l10n.optionalAnalysis,
              selected: analysis,
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 28, bottom: 10, left: 4),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}

void showMessage(BuildContext context, String message) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

Future<void> guardAction(
  BuildContext context,
  Future<void> Function() action, {
  String? success,
}) async {
  try {
    await action();
    if (success != null && context.mounted) showMessage(context, success);
  } catch (e) {
    if (context.mounted) {
      final code = switch (e) {
        FormatException() => e.message,
        AppFailure() => e.message,
        StateError() => e.message,
        _ => 'operationFailed',
      };
      showMessage(context, context.l10n.message(code));
    }
  }
}

/// Marketing names of the bundled offline model variants.
String modelDisplayName(String id) => switch (id) {
  'turbo' => 'Large V3 Turbo',
  'small' => 'Small',
  _ => id,
};

String durationLabel(double seconds) {
  final n = seconds.floor();
  return '${(n ~/ 60).toString().padLeft(2, '0')}:${(n % 60).toString().padLeft(2, '0')}';
}
