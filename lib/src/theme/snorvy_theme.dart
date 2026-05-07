import 'package:flutter/material.dart';

class SnorvyTheme {
  static const ink = Color(0xFF18211F);
  static const moss = Color(0xFF1C7C6E);
  static const mint = Color(0xFFE4F3EF);
  static const amber = Color(0xFFEAA94B);
  static const coral = Color(0xFFE56A54);
  static const paper = Color(0xFFFAF8F3);
  static const midnight = Color(0xFF0A0D17);
  static const midnight2 = Color(0xFF0E1220);
  static const midnightSurface = Color(0xFF151A27);
  static const midnightSurfaceHi = Color(0xFF1B2130);
  static const midnightBorder = Color(0xFF262C3A);
  static const midnightText = Color(0xFFECEDF3);
  static const midnightTextDim = Color(0xA0ECEDF3);
  static const midnightTextFaint = Color(0x66ECEDF3);
  static const neuralMint = Color(0xFF71E3CF);
  static const talkAmber = Color(0xFFE6C16E);
  static const danger = Color(0xFFFF8A8A);

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
          primary: neuralMint,
          onPrimary: midnight,
          primaryContainer: const Color(0x2A71E3CF),
          onPrimaryContainer: neuralMint,
          secondary: talkAmber,
          tertiary: danger,
          surface: midnight,
          onSurface: midnightText,
          surfaceContainerLowest: const Color(0x14FFFFFF),
          surfaceContainerLow: midnightSurface,
          surfaceContainer: midnightSurfaceHi,
          surfaceContainerHigh: const Color(0xFF222838),
          outline: midnightBorder,
          outlineVariant: const Color(0x24FFFFFF),
          onSurfaceVariant: midnightTextDim,
        );

    return _base(colorScheme);
  }

  static ThemeData _base(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      fontFamily: 'Roboto',
      textTheme: Typography.material2021().black.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? colorScheme.surfaceContainerLow : colorScheme.surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            color: isDark ? midnightBorder : colorScheme.outlineVariant,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 76,
        backgroundColor: isDark
            ? midnight2.withValues(alpha: 0.92)
            : colorScheme.surface,
        indicatorColor: isDark ? const Color(0x2A71E3CF) : mint,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
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
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        selectedColor: colorScheme.primaryContainer,
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? const Color(0x1FFFFFFF) : colorScheme.outlineVariant,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  static TextStyle displayStyle(
    BuildContext context, {
    double size = 56,
    Color? color,
  }) {
    return TextStyle(
      color: color ?? Theme.of(context).colorScheme.onSurface,
      fontFamily: 'Georgia',
      fontSize: size,
      fontWeight: FontWeight.w400,
      height: 0.95,
      letterSpacing: 0,
    );
  }

  static TextStyle labelStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      fontSize: 10.5,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.1,
    );
  }
}
