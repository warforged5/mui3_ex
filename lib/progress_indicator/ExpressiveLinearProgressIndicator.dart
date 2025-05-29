import 'dart:math' as math;
import 'package:flutter/material.dart';

class ExpressiveLinearProgressIndicator extends StatefulWidget {
  const ExpressiveLinearProgressIndicator({
    Key? key,
    required this.progress,
    this.color,
    this.trackColor,
    this.strokeWidth = 4.0,
    this.trackStrokeWidth = 4.0,
    this.gapSize = 2.0,
    this.stopSize = 4.0,
    this.amplitude,
    this.wavelength = 40.0,
    this.waveSpeed = 40.0,
    this.width = 240.0,
    this.height = 14.0,
  }) : super(key: key);

  final double progress;
  final Color? color;
  final Color? trackColor;
  final double strokeWidth;
  final double trackStrokeWidth;
  final double gapSize;
  final double stopSize;
  final double Function(double progress)? amplitude;
  final double wavelength;
  final double waveSpeed;
  final double width;
  final double height;

  @override
  State<ExpressiveLinearProgressIndicator> createState() => 
      _ExpressiveLinearProgressIndicatorState();
}

class _ExpressiveLinearProgressIndicatorState 
    extends State<ExpressiveLinearProgressIndicator>
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
    // Default amplitude function from Android implementation
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
        width: widget.width,
        height: widget.height,
        child: AnimatedBuilder(
          animation: _waveController,
          builder: (context, child) {
            return CustomPaint(
              painter: _LinearWavyProgressPainter(
                progress: widget.progress.clamp(0.0, 1.0),
                color: widget.color ?? colorScheme.primary,
                trackColor: widget.trackColor ?? colorScheme.primary.withOpacity(0.24),
                strokeWidth: widget.strokeWidth,
                trackStrokeWidth: widget.trackStrokeWidth,
                gapSize: widget.gapSize,
                stopSize: widget.stopSize,
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

class _LinearWavyProgressPainter extends CustomPainter {
  _LinearWavyProgressPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
    required this.trackStrokeWidth,
    required this.gapSize,
    required this.stopSize,
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
  final double stopSize;
  final double amplitude;
  final double wavelength;
  final double waveOffset;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.height / 2;
    final progressWidth = size.width * progress;
    
    // Draw track
    _drawTrack(canvas, size, center);
    
    // Draw progress with wave
    if (progress > 0) {
      _drawProgress(canvas, size, center, progressWidth);
    }
    
    // Draw stop indicator
    _drawStopIndicator(canvas, size, center);
  }

  void _drawTrack(Canvas canvas, Size size, double center) {
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = trackStrokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, center),
      Offset(size.width, center),
      trackPaint,
    );
  }

  void _drawProgress(Canvas canvas, Size size, double center, double progressWidth) {
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (amplitude > 0) {
      final path = Path();
      final waveAmplitude = amplitude * (size.height / 2 - strokeWidth);
      bool started = false;

      for (double x = 0; x <= progressWidth; x += 1) {
        final waveY = center + waveAmplitude * 
            math.sin(2 * math.pi * (x + waveOffset) / wavelength);
        
        if (!started) {
          path.moveTo(x, waveY);
          started = true;
        } else {
          path.lineTo(x, waveY);
        }
      }

      canvas.drawPath(path, progressPaint);
    } else {
      canvas.drawLine(
        Offset(0, center),
        Offset(progressWidth, center),
        progressPaint,
      );
    }
  }

  void _drawStopIndicator(Canvas canvas, Size size, double center) {
    if (stopSize > 0) {
      final stopPaint = Paint()
        ..color = trackColor
        ..strokeWidth = stopSize
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(size.width, center),
        Offset(size.width, center),
        stopPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LinearWavyProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.waveOffset != waveOffset ||
           oldDelegate.amplitude != amplitude;
  }
}
