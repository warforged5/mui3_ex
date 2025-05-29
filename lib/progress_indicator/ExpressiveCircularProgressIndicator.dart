import 'dart:math' as math;
import 'package:flutter/material.dart';

class ExpressiveCircularProgressIndicator extends StatefulWidget {
  const ExpressiveCircularProgressIndicator({
    Key? key,
    required this.progress,
    this.color,
    this.trackColor,
    this.strokeWidth = 4.0,
    this.trackStrokeWidth = 4.0,
    this.gapSize = 2.0,
    this.amplitude,
    this.wavelength = 40.0,
    this.waveSpeed = 40.0,
    this.size = 48.0,
  }) : super(key: key);

  final double progress;
  final Color? color;
  final Color? trackColor;
  final double strokeWidth;
  final double trackStrokeWidth;
  final double gapSize;
  final double Function(double progress)? amplitude;
  final double wavelength;
  final double waveSpeed;
  final double size;

  @override
  State<ExpressiveCircularProgressIndicator> createState() => 
      _ExpressiveCircularProgressIndicatorState();
}

class _ExpressiveCircularProgressIndicatorState 
    extends State<ExpressiveCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: Duration(milliseconds: (1000 * widget.wavelength / widget.waveSpeed).round()),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  double _getAmplitude(double progress) {
    if (widget.amplitude != null) {
      return widget.amplitude!(progress);
    }
    // Default amplitude function
    if (progress <= 0.1 || progress >= 0.95) {
      return 0.0;
    }
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      value: '${(widget.progress * 100).round()}%',
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _waveController,
          builder: (context, child) {
            return CustomPaint(
              painter: _CircularWavyProgressPainter(
                progress: widget.progress.clamp(0.0, 1.0),
                color: widget.color ?? colorScheme.primary,
                trackColor: widget.trackColor ?? colorScheme.primary.withOpacity(0.24),
                strokeWidth: widget.strokeWidth,
                trackStrokeWidth: widget.trackStrokeWidth,
                gapSize: widget.gapSize,
                amplitude: _getAmplitude(widget.progress),
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

class _CircularWavyProgressPainter extends CustomPainter {
  _CircularWavyProgressPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
    required this.trackStrokeWidth,
    required this.gapSize,
    required this.amplitude,
    required this.wavelength,
    required this.waveOffset,
  });

  final double progress;
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

    // Draw progress with wave
    if (progress > 0) {
      _drawCircularProgress(canvas, center, radius);
    }
  }

  void _drawCircularProgress(Canvas canvas, Offset center, double radius) {
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;

    if (amplitude > 0) {
      final path = Path();
      final waveAmplitude = amplitude * strokeWidth * 0.5;
      bool started = false;

      // Create wavy circular path
      for (double angle = 0; angle <= sweepAngle; angle += 0.01) {
        final waveRadius = radius + waveAmplitude * 
            math.sin((angle * radius + waveOffset) * 2 * math.pi / wavelength);
        
        final x = center.dx + waveRadius * math.cos(angle - math.pi / 2);
        final y = center.dy + waveRadius * math.sin(angle - math.pi / 2);
        
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
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularWavyProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.waveOffset != waveOffset ||
           oldDelegate.amplitude != amplitude;
  }
}
