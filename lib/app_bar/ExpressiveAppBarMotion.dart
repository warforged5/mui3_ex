import 'package:flutter/material.dart';

class ExpressiveAppBarMotion {
  ExpressiveAppBarMotion._();

  // Motion durations from MotionSchemeKeyTokens
  static const Duration defaultEffects = Duration(milliseconds: 200);
  static const Duration fastSpatial = Duration(milliseconds: 150);
  static const Duration defaultSpatial = Duration(milliseconds: 300);
  static const Duration slowSpatial = Duration(milliseconds: 500);
  
  // Spring curves for M3 Expressive animations
  static const Curve expressiveSpring = Curves.easeOutBack;
  static const Curve standardSpring = Curves.easeOut;
  static const Curve spatialSpring = Curves.elasticOut;
  static const Curve effectsSpring = Curves.easeInOutCubic;
  
  // Container color transition easing (from TopTitleAlphaEasing)
  static const Curve containerColorEasing = Cubic(0.8, 0.0, 0.8, 0.15);
}
