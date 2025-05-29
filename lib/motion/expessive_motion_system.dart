import 'package:flutter/material.dart';


/// Implements spring-based animations matching Android Compose implementation
class ExpressiveMotion {
  ExpressiveMotion._();

  // Motion Schemes
  static const MotionScheme expressive = MotionScheme.expressive();
  static MotionScheme standard = MotionScheme.standard();

  // Spring Tokens - Spatial (with overshoot for movement)
  static const Duration fastSpatial = Duration(milliseconds: 150);
  static const Duration defaultSpatial = Duration(milliseconds: 300);
  static const Duration slowSpatial = Duration(milliseconds: 500);
  
  // Spring Tokens - Effects (no overshoot for color/opacity)
  static const Duration fastEffects = Duration(milliseconds: 100);
  static const Duration defaultEffects = Duration(milliseconds: 200);
  static const Duration slowEffects = Duration(milliseconds: 300);
  
  // Spring Curves (approximating spring physics with stiffness/damping)
  static const Curve expressiveSpring = Curves.easeOutBack; // Expressive with bounce
  static const Curve standardSpring = Curves.easeOut; // Standard minimal bounce
  static const Curve spatialSpring = Curves.elasticOut; // For movement animations
  static const Curve effectsSpring = Curves.easeInOut; // For color/opacity changes
  static const Curve containerColorEasing = Curves.easeInOutCubicEmphasized; // App bar colors

  // Buttery smooth curves for M3 Expressive hero moments
  static const Curve butterySmoothSpatial = Curves.easeInOutCubicEmphasized;
  static const Curve butterySmoothEffects = Curves.easeOutCubic;
  static const Curve butterySmoothScale = Curves.easeOutQuart;
  static const Curve butterySmoothOpacity = Curves.easeInOutQuart;

  // App Bar specific motion tokens
  static const Duration appBarColorTransition = Duration(milliseconds: 200);
  static const Duration appBarScrollTransition = Duration(milliseconds: 300);
  static const Duration appBarTitleTransition = Duration(milliseconds: 400);
}

/// Motion Scheme for Material 3 Expressive with spring configuration
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
    fastSpatial: Duration(milliseconds: 100),
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

/// Spring Animation Controller for M3 Expressive physics
class ExpressiveSpringController extends AnimationController {
  ExpressiveSpringController({
    required super.vsync,
    required this.motionScheme,
    required this.springType,
    required this.springSpeed,
  }) : super(
    duration: _getDuration(motionScheme, springType, springSpeed),
  );

  final MotionScheme motionScheme;
  final SpringType springType;
  final SpringSpeed springSpeed;

  static Duration _getDuration(MotionScheme scheme, SpringType type, SpringSpeed speed) {
    if (type == SpringType.spatial) {
      switch (speed) {
        case SpringSpeed.fast: return scheme.fastSpatial;
        case SpringSpeed.defaultSpeed: return scheme.defaultSpatial;
        case SpringSpeed.slow: return scheme.slowSpatial;
      }
    } else {
      switch (speed) {
        case SpringSpeed.fast: return scheme.fastEffects;
        case SpringSpeed.defaultSpeed: return scheme.defaultEffects;
        case SpringSpeed.slow: return scheme.slowEffects;
      }
    }
  }

  Curve get springCurve {
    return springType == SpringType.spatial 
      ? motionScheme.spatialCurve 
      : motionScheme.effectsCurve;
  }
}

enum SpringType { spatial, effects }
enum SpringSpeed { fast, defaultSpeed, slow }

// lib/app_bar/expressive_app_bar_motion.dart
/// Motion configuration specifically for M3 Expressive App Bars with buttery smooth animations
class ExpressiveAppBarMotion {
  ExpressiveAppBarMotion._();

  // Motion durations matching MotionSchemeKeyTokens
  static const Duration defaultEffects = Duration(milliseconds: 200);
  static const Duration fastSpatial = Duration(milliseconds: 150);
  static const Duration defaultSpatial = Duration(milliseconds: 300);
  static const Duration slowSpatial = Duration(milliseconds: 500);

  // Buttery smooth spring curves for M3 Expressive animations
  static const Curve expressiveSpring = Curves.easeOutBack;
  static const Curve spatialSpring = Curves.elasticOut;
  static const Curve effectsSpring = Curves.easeInOut;
  static const Curve containerColorEasing = Curves.easeInOutCubicEmphasized;

  // Ultra-smooth curves for hero moments and collapsing animations
  static const Curve butterySmoothTitleCollapse = Curves.easeInOutCubicEmphasized;
  static const Curve butterySmoothOpacityFade = Curves.easeOutCubic;
  static const Curve butterySmoothScaleTransform = Curves.easeOutQuart;
  static const Curve butterySmoothOffsetTransition = Curves.easeOutQuart;

  // App bar specific configurations with enhanced smoothness
  static const Duration titleFadeTransition = Duration(milliseconds: 150);
  static const Duration subtitleFadeTransition = Duration(milliseconds: 200);
  static const Duration heightChangeTransition = Duration(milliseconds: 300);
  static const Duration backgroundColorTransition = Duration(milliseconds: 200);
  
  // Enhanced timing for large hero moments
  static const Duration largeHeroTitleTransition = Duration(milliseconds: 400);
  static const Duration mediumTitleTransition = Duration(milliseconds: 350);
}
