import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vox_local/ui/theme.dart';
import 'package:vox_local/ui/widgets/common.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('notice action contrast meets AA in ${brightness.name}', (
      tester,
    ) async {
      final theme = VoxTheme.make(brightness);
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: StatusNote(
              '合成状态',
              action: TextButton(onPressed: () {}, child: const Text('选择模型')),
            ),
          ),
        ),
      );
      final context = tester.element(find.byType(TextButton));
      final foreground = TextButtonTheme.of(context).style!.foregroundColor!
          .resolve({})!;
      final a = foreground.computeLuminance(),
          b = theme.colorScheme.secondaryContainer.computeLuminance();
      expect((max(a, b) + .05) / (min(a, b) + .05), greaterThanOrEqualTo(4.5));
    });
  }
}
