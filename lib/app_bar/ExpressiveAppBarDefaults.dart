import 'package:flutter/material.dart';

class ExpressiveAppBarDefaults {
  ExpressiveAppBarDefaults._();

  // Default heights from the Kotlin tokens
  static const double topAppBarExpandedHeight = 64.0;
  static const double mediumAppBarCollapsedHeight = 64.0;
  static const double mediumAppBarExpandedHeight = 112.0;
  static const double mediumFlexibleAppBarWithoutSubtitleExpandedHeight = 112.0;
  static const double mediumFlexibleAppBarWithSubtitleExpandedHeight = 140.0;
  static const double largeAppBarCollapsedHeight = 64.0;
  static const double largeAppBarExpandedHeight = 152.0;
  static const double largeFlexibleAppBarWithoutSubtitleExpandedHeight = 152.0;
  static const double largeFlexibleAppBarWithSubtitleExpandedHeight = 180.0;

  // Padding values
  static const double horizontalPadding = 4.0;
  static const double titleInset = 16.0 - horizontalPadding;
  static const double mediumTitleBottomPadding = 24.0;
  static const double largeTitleBottomPadding = 28.0;

  /// Creates app bar colors matching M3 Expressive design
  static AppBarTheme expressiveAppBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      centerTitle: false,
      titleSpacing: horizontalPadding,
      titleTextStyle: ThemeData().textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    );
  }
}