import 'dart:math' as math;
import 'package:flutter/material.dart';

class ExpressiveCircularProgressIndicatorIndeterminate extends StatefulWidget {
  const ExpressiveCircularProgressIndicatorIndeterminate({
    Key? key,
    this.color,
    this.trackColor,
    this.strokeWidth = 4.0,
    this.trackStrokeWidth = 4.0,
    this.gapSize = 2.0,
    this.amplitude = 1.0,
    this.wavelength = 40.0,
    this.waveSpeed = 40.0,
    this.size = 48.0,
  }) : super(key: key);

  final Color? color;
  final Color? trackColor;
  final double strokeWidth;
  final double trackStrokeWidth;
  final double gapSize;
  final double amplitude;
  final double wavelength;
  final double waveSpeed;
  final double size;

  @override
  State<ExpressiveCircularProgressIndicatorIndeterminate> createState() => 
      _ExpressiveCircularProgressIndicatorIndeterminateState();
}

class _ExpressiveCircularProgressIndicatorIndeterminateState 
    extends State<ExpressiveCircularProgressIndicatorIndeterminate>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    
    _waveController = AnimationController(
      duration: Duration(milliseconds: (1000 * widget.wavelength / widget.waveSpeed).round()),
      vsync: this,
    )..repeat();

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: 'Loading',
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: Listenable.merge([_waveController, _rotationController]),
          builder: (context, child) {
            return CustomPaint(
              painter: _CircularWavyProgressIndeterminatePainter(
                rotation: _rotationController.value * 2 * math.pi,
                color: widget.color ?? colorScheme.primary,
                trackColor: widget.trackColor ?? colorScheme.primary.withOpacity(0.24),
                strokeWidth: widget.strokeWidth,
                trackStrokeWidth: widget.trackStrokeWidth,
                gapSize: widget.gapSize,
                amplitude: widget.amplitude.clamp(0.0, 1.0),
                wavelength: widget.wavelength,
                waveOffset: _waveController.value * widget.wavelength,
              ),
            );
          },
        ),
      ),
    );
  }
}
class _CircularWavyProgressIndeterminatePainter extends CustomPainter {
  _CircularWavyProgressIndeterminatePainter({
    required this.rotation,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
    required this.trackStrokeWidth,
    required this.gapSize,
    required this.amplitude,
    required this.wavelength,
    required this.waveOffset,
  });

  final double rotation;
  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final double trackStrokeWidth;
  final double gapSize;
  final double amplitude;
  final double wavelength;
  final double waveOffset;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    // Draw track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = trackStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Draw animated progress arc
    _drawAnimatedArc(canvas, center, radius);
  }

  void _drawAnimatedArc(Canvas canvas, Offset center, double radius) {
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = math.pi; // Half circle for indeterminate
    final startAngle = rotation - math.pi / 2;

    if (amplitude > 0) {
      final path = Path();
      final waveAmplitude = amplitude * strokeWidth * 0.5;
      bool started = false;

      for (double angle = startAngle; angle <= startAngle + sweepAngle; angle += 0.01) {
        final waveRadius = radius + waveAmplitude * 
            math.sin((angle * radius + waveOffset) * 2 * math.pi / wavelength);
        
        final x = center.dx + waveRadius * math.cos(angle);
        final y = center.dy + waveRadius * math.sin(angle);
        
        if (!started) {
          path.moveTo(x, y);
          started = true;
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, progressPaint);
    } else {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularWavyProgressIndeterminatePainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
           oldDelegate.waveOffset != waveOffset;
  }
}

