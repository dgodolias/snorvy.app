import 'package:flutter/material.dart';

class SnorvyTheme {
  static const ink = Color(0xFF18211F);
  static const moss = Color(0xFF1C7C6E);
  static const mint = Color(0xFFE4F3EF);
  static const amber = Color(0xFFEAA94B);
  static const coral = Color(0xFFE56A54);
  static const paper = Color(0xFFFAF8F3);

  static ThemeData light() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: moss,
          brightness: Brightness.light,
        ).copyWith(
          primary: moss,
          secondary: amber,
          tertiary: coral,
          surface: paper,
          onSurface: ink,
        );

    return _base(colorScheme);
  }

  static ThemeData dark() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: moss,
          brightness: Brightness.dark,
        ).copyWith(
          primary: const Color(0xFF6DD3C0),
          secondary: amber,
          tertiary: const Color(0xFFFF9A83),
          surface: const Color(0xFF101614),
        );

    return _base(colorScheme);
  }

  static ThemeData _base(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: Typography.material2021().black.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLowest,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: mint,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        selectedColor: colorScheme.primaryContainer,
      ),
    );
  }
}
