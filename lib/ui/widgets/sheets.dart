import 'package:flutter/material.dart';

import '../../l10n/localization.dart';

/// Bottom sheets replace Material dialogs, dropdowns and popup menus so
/// every choice, confirmation and action list shares one surface on both
/// platforms and sits in the thumb zone.
Future<T?> showVoxSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) => showModalBottomSheet<T>(
  context: context,
  useSafeArea: true,
  isScrollControlled: true,
  builder: (context) => _SheetFrame(child: builder(context)),
);

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      // Keep the content above the keyboard when a sheet carries a field.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      // heightFactor keeps the sheet as tall as its content, not the screen.
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 4),
                  decoration: BoxDecoration(
                    color: colors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SheetTitle extends StatelessWidget {
  const SheetTitle(this.text, {this.message, super.key});
  final String text;
  final String? message;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: theme.textTheme.titleLarge),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ChoiceOption<T> {
  const ChoiceOption(this.value, this.label, {this.description, this.key});
  final T value;
  final String label;
  final String? description;
  final Key? key;
}

/// Single-select list with the current value marked. Returns null when
/// dismissed.
Future<T?> showChoiceSheet<T>(
  BuildContext context, {
  required String title,
  required List<ChoiceOption<T>> options,
  T? selected,
}) => showVoxSheet<T>(
  context,
  builder: (context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SheetTitle(title),
        for (final option in options)
          InkWell(
            key: option.key,
            borderRadius: BorderRadius.circular(14),
            onTap: () => Navigator.pop(context, option.value),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(option.label, style: text.bodyLarge),
                        if (option.description != null)
                          Text(
                            option.description!,
                            style: text.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (option.value == selected)
                    Icon(Icons.check_rounded, color: colors.primary),
                ],
              ),
            ),
          ),
      ],
    );
  },
);

class SheetAction {
  const SheetAction(
    this.id,
    this.label, {
    required this.icon,
    this.destructive = false,
    this.enabled = true,
    this.key,
  });
  final String id;
  final String label;
  final IconData icon;
  final bool destructive;
  final bool enabled;
  final Key? key;
}

/// Action list with an explicit cancel. Returns the chosen action id.
Future<String?> showActionSheet(
  BuildContext context, {
  String? title,
  required List<SheetAction> actions,
}) => showVoxSheet<String>(
  context,
  builder: (context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
          ),
        for (final action in actions)
          InkWell(
            key: action.key,
            borderRadius: BorderRadius.circular(14),
            onTap: action.enabled
                ? () => Navigator.pop(context, action.id)
                : null,
            child: Opacity(
              opacity: action.enabled ? 1 : .45,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Icon(
                      action.icon,
                      size: 22,
                      color: action.destructive
                          ? colors.error
                          : colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        action.label,
                        style: text.bodyLarge?.copyWith(
                          color: action.destructive ? colors.error : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: 8),
        FilledButton.tonal(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
      ],
    );
  },
);

/// Confirmation with the decisive button first and cancel below it.
Future<bool> confirmSheet(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = true,
}) async {
  final confirmed = await showVoxSheet<bool>(
    context,
    builder: (context) {
      final colors = Theme.of(context).colorScheme;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SheetTitle(title, message: message),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: destructive
                ? FilledButton.styleFrom(
                    backgroundColor: colors.error,
                    foregroundColor: colors.onError,
                  )
                : null,
            child: Text(confirmLabel),
          ),
          const SizedBox(height: 10),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}
