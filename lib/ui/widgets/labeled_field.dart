import 'package:flutter/material.dart';

/// Field with a fixed label above it and a steady help line below, so the
/// layout does not jump the way floating labels and helper text do. When
/// [controller] and [maxLength] are given the count sits beside the label.
class LabeledField extends StatelessWidget {
  const LabeledField({
    required this.label,
    required this.child,
    this.help,
    this.controller,
    this.maxLength,
    super.key,
  });
  final String label;
  final Widget child;
  final String? help;
  final TextEditingController? controller;
  final int? maxLength;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final caption = text.labelLarge?.copyWith(color: colors.onSurfaceVariant);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
          child: Row(
            children: [
              Expanded(child: Text(label, style: caption)),
              if (controller != null && maxLength != null)
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller!,
                  builder: (context, value, _) => Text(
                    '${value.text.characters.length}/$maxLength',
                    style: caption,
                  ),
                ),
            ],
          ),
        ),
        child,
        if (help != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            child: Text(
              help!,
              style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          ),
      ],
    );
  }
}
