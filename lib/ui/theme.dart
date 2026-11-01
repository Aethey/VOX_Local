import 'package:flutter/material.dart';

abstract final class VoxTheme {
  static const cream = Color(0xFFF4E4BC);
  static const paper = Color(0xFFFCF8EF);
  static const sage = Color(0xFF7CB9A8);
  static const forest = Color(0xFF315D4F);
  static const ink = Color(0xFF3A3226);
  static const coral = Color(0xFFE8A87C);
  static ThemeData make(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(seedColor: sage, brightness: brightness)
        .copyWith(
          primary: dark ? sage : forest,
          onPrimary: dark ? ink : paper,
          surface: dark ? const Color(0xFF282B24) : paper,
          onSurface: dark ? const Color(0xFFF2E7CE) : ink,
          onSurfaceVariant: dark
              ? const Color(0xFFD0C7B2)
              : const Color(0xFF665E4C),
          secondaryContainer: dark
              ? const Color(0xFF3D5043)
              : const Color(0xFFDDE9D7),
          onSecondaryContainer: dark ? const Color(0xFFE0EBD8) : forest,
          outlineVariant: dark
              ? const Color(0xFF565C4B)
              : const Color(0xFFDBD4BC),
        );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
    );
    return base.copyWith(
      scaffoldBackgroundColor: dark
          ? const Color(0xFF22251F)
          : const Color(0xFFF8F1DF),
      textTheme: base.textTheme.copyWith(
        // No negative tracking: CJK glyphs collide under it.
        headlineLarge: base.textTheme.headlineLarge?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          height: 1.35,
          letterSpacing: 0,
        ),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(
          fontSize: 17,
          height: 1.8,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          fontSize: 15,
          height: 1.65,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: dark
            ? const Color(0xFF22251F)
            : const Color(0xFFF8F1DF),
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.secondaryContainer,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: scheme.onSurface.withValues(alpha: .32),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.onSurface,
        contentTextStyle: TextStyle(color: scheme.surface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
