import 'package:flutter/material.dart';

class ExpressiveProgressIndicatorDefaults {
  ExpressiveProgressIndicatorDefaults._();

  /// Default progress animation spec matching Android MotionTokens
  static const Duration progressAnimationDuration = Duration(milliseconds: 500);

  /// Default linear progress indicator dimensions
  static const double linearWidth = 240.0;
  static const double linearHeight = 14.0;
  static const double linearStrokeWidth = 4.0;
  static const double linearTrackStrokeWidth = 4.0;

  /// Default circular progress indicator dimensions  
  static const double circularSize = 48.0;
  static const double circularStrokeWidth = 4.0;
  static const double circularTrackStrokeWidth = 4.0;

  /// Default wave parameters
  static const double linearDeterminateWavelength = 40.0;
  static const double linearIndeterminateWavelength = 32.0;
  static const double circularWavelength = 40.0;
  static const double defaultGapSize = 2.0;
  static const double defaultStopSize = 4.0;

  /// Default amplitude function (matches Android implementation)
  static double indicatorAmplitude(double progress) {
    if (progress <= 0.1 || progress >= 0.95) {
      return 0.0;
    }
    return 1.0;
  }

  /// Progress indicator colors
  static Color indicatorColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  static Color trackColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary.withOpacity(0.24);
  }
}