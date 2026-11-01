import 'package:flutter/material.dart';

import 'sheets.dart';

/// Inset grouped container: related rows share one surface instead of being
/// separated by full-width dividers.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({required this.children, super.key});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // Material rather than a decorated box so row ink stays visible.
    return Material(
      color: colors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.only(left: 52),
                child: Divider(height: 1, color: colors.outlineVariant),
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// One row of a [SettingsGroup]: icon, title, optional subtitle, a current
/// value on the right and a chevron when it navigates or opens a sheet.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.onTap,
    this.trailing,
    this.enabled = true,
    super.key,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? value;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final muted = text.bodyMedium?.copyWith(color: colors.onSurfaceVariant);
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : .5,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          // The value keeps its natural width (capped) and the title yields,
          // so a short title never forces a short value to wrap.
          child: LayoutBuilder(
            builder: (context, constraints) => Row(
              children: [
                Icon(icon, size: 22, color: colors.onSurfaceVariant),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: text.bodyLarge),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: muted,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (value != null) ...[
                  const SizedBox(width: 12),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth * .55,
                    ),
                    child: Text(
                      value!,
                      style: muted,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
                if (onTap != null && trailing == null)
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 22,
                    color: colors.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Row whose value is picked from a single-select sheet.
class ChoiceRow<T> extends StatelessWidget {
  const ChoiceRow({
    required this.icon,
    required this.title,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });
  final IconData icon;
  final String title;
  final List<ChoiceOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    final current = options.where((o) => o.value == selected).firstOrNull;
    return SettingsRow(
      icon: icon,
      title: title,
      value: current?.label ?? '$selected',
      enabled: enabled,
      onTap: () async {
        final picked = await showChoiceSheet<T>(
          context,
          title: title,
          options: options,
          selected: selected,
        );
        if (picked != null && picked != selected) onChanged(picked);
      },
    );
  }
}
