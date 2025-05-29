import 'package:flutter/material.dart';

/// Material 3 Expressive Theme Extensions
class ExpressiveTheme {
  ExpressiveTheme._();

  /// Creates a Material 3 Expressive theme
  static ThemeData expressiveTheme({
    required ColorScheme colorScheme,
    TextTheme? textTheme,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _expressiveTextTheme(textTheme),
      appBarTheme: _expressiveAppBarTheme(colorScheme),
    );
  }

  static TextTheme _expressiveTextTheme(TextTheme? base) {
    final textTheme = base ?? ThemeData().textTheme;
    
    return textTheme.copyWith(
      // Emphasized typography for expressive design
      headlineLarge: textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
      ),
      headlineSmall: textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static AppBarTheme _expressiveAppBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 16,
    );
  }
}