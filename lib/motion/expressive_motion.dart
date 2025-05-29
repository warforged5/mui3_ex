import 'package:flutter/material.dart';

/// Material 3 Expressive Motion System
/// Provides spring-based animations and motion tokens
class ExpressiveMotion {
  ExpressiveMotion._();

  // Motion Schemes
  static MotionScheme expressive = MotionScheme.expressive();
  static MotionScheme standard = MotionScheme.standard();

  // Spring Durations (approximated for Flutter)
  static const Duration fastSpatial = Duration(milliseconds: 200);
  static const Duration defaultSpatial = Duration(milliseconds: 300);
  static const Duration slowSpatial = Duration(milliseconds: 500);
  
  static const Duration fastEffects = Duration(milliseconds: 100);
  static const Duration defaultEffects = Duration(milliseconds: 200);
  static const Duration slowEffects = Duration(milliseconds: 300);
  
  // Spring Curves (approximating spring physics)
  static const Curve expressiveSpring = Curves.easeOutBack;
  static const Curve standardSpring = Curves.easeOut;
  static const Curve spatialSpring = Curves.elasticOut;
  static const Curve effectsSpring = Curves.easeInOut;
}

/// Motion Scheme for Material 3 Expressive
class MotionScheme {
  const MotionScheme({
    required this.fastSpatial,
    required this.defaultSpatial,
    required this.slowSpatial,
    required this.fastEffects,
    required this.defaultEffects,
    required this.slowEffects,
    required this.spatialCurve,
    required this.effectsCurve,
  });

  const MotionScheme.expressive() : this(
    fastSpatial: ExpressiveMotion.fastSpatial,
    defaultSpatial: ExpressiveMotion.defaultSpatial,
    slowSpatial: ExpressiveMotion.slowSpatial,
    fastEffects: ExpressiveMotion.fastEffects,
    defaultEffects: ExpressiveMotion.defaultEffects,
    slowEffects: ExpressiveMotion.slowEffects,
    spatialCurve: ExpressiveMotion.expressiveSpring,
    effectsCurve: ExpressiveMotion.effectsSpring,
  );

  MotionScheme.standard() : this(
    fastSpatial: Duration(milliseconds: 150),
    defaultSpatial: Duration(milliseconds: 250),
    slowSpatial: Duration(milliseconds: 400),
    fastEffects: Duration(milliseconds: 75),
    defaultEffects: Duration(milliseconds: 150),
    slowEffects: Duration(milliseconds: 250),
    spatialCurve: ExpressiveMotion.standardSpring,
    effectsCurve: ExpressiveMotion.effectsSpring,
  );

  final Duration fastSpatial;
  final Duration defaultSpatial;
  final Duration slowSpatial;
  final Duration fastEffects;
  final Duration defaultEffects;
  final Duration slowEffects;
  final Curve spatialCurve;
  final Curve effectsCurve;
}
