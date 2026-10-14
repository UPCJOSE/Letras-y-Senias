import 'package:flutter/material.dart';

abstract final class AppColors {
  static const blue = Color(0xFF2563EB);
  static const blueDark = Color(0xFF143E91);
  static const background = Color(0xFFF5F7FA);
  static const green = Color(0xFF22C55E);
  static const ink = Color(0xFF102A43);
  static const muted = Color(0xFF6B7A99);
  static const lavender = Color(0xFFEDE9FE);
  static const paleBlue = Color(0xFFDFECFF);
  static const paleYellow = Color(0xFFFFF2C7);
  static const paleGreen = Color(0xFFDDF7E7);
}

abstract final class AppTheme {
  static ThemeData light({bool highContrast = false}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      brightness: Brightness.light,
      surface: Colors.white,
      contrastLevel: highContrast ? 1 : 0,
    );
    return _base(
      scheme,
    ).copyWith(scaffoldBackgroundColor: AppColors.background);
  }

  static ThemeData dark({bool highContrast = false}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF80A9FF),
      brightness: Brightness.dark,
      contrastLevel: highContrast ? 1 : 0,
    );
    return _base(
      scheme,
    ).copyWith(scaffoldBackgroundColor: const Color(0xFF0E1726));
  }

  static ThemeData _base(ColorScheme scheme) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Arial',
      visualDensity: VisualDensity.standard,
    );
    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displaySmall: base.textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -1.4,
        ),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.7,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: .7)),
        ),
      ),
    );
  }
}
