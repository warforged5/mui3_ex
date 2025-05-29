import 'dart:math' as math;
import 'package:flutter/material.dart';

class ExpressiveLinearProgressIndicatorIndeterminate extends StatefulWidget {
  const ExpressiveLinearProgressIndicatorIndeterminate({
    Key? key,
    this.color,
    this.trackColor,
    this.strokeWidth = 4.0,
    this.trackStrokeWidth = 4.0,
    this.gapSize = 2.0,
    this.amplitude = 1.0,
    this.wavelength = 32.0,
    this.waveSpeed = 32.0,
    this.width = 240.0,
    this.height = 14.0,
  }) : super(key: key);

  final Color? color;
  final Color? trackColor;
  final double strokeWidth;
  final double trackStrokeWidth;
  final double gapSize;
  final double amplitude;
  final double wavelength;
  final double waveSpeed;
  final double width;
  final double height;

  @override
  State<ExpressiveLinearProgressIndicatorIndeterminate> createState() => 
      _ExpressiveLinearProgressIndicatorIndeterminateState();
}

class _ExpressiveLinearProgressIndicatorIndeterminateState 
    extends State<ExpressiveLinearProgressIndicatorIndeterminate>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _progressController;
  late Animation<double> _firstLineHead;
  late Animation<double> _firstLineTail;
  late Animation<double> _secondLineHead;
  late Animation<double> _secondLineTail;

  @override
  void initState() {
    super.initState();
    
    _waveController = AnimationController(
      duration: Duration(milliseconds: (1000 * widget.wavelength / widget.waveSpeed).round()),
      vsync: this,
    )..repeat();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Indeterminate animation curves (similar to Android implementation)
    _firstLineHead = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: const Interval(0.0, 0.75, curve: Curves.easeInOut),
      ),
    );

    _firstLineTail = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: const Interval(0.33, 1.0, curve: Curves.easeInOut),
      ),
    );

    _secondLineHead = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _secondLineTail = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: 'Loading',
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AnimatedBuilder(
          animation: Listenable.merge([_waveController, _progressController]),
          builder: (context, child) {
            return CustomPaint(
              painter: _LinearWavyProgressIndeterminatePainter(
                firstLineHead: _firstLineHead.value,
                firstLineTail: _firstLineTail.value,
                secondLineHead: _secondLineHead.value,
                secondLineTail: _secondLineTail.value,
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

class _LinearWavyProgressIndeterminatePainter extends CustomPainter {
  _LinearWavyProgressIndeterminatePainter({
    required this.firstLineHead,
    required this.firstLineTail,
    required this.secondLineHead,
    required this.secondLineTail,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
    required this.trackStrokeWidth,
    required this.gapSize,
    required this.amplitude,
    required this.wavelength,
    required this.waveOffset,
  });

  final double firstLineHead;
  final double firstLineTail;
  final double secondLineHead;
  final double secondLineTail;
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
    final center = size.height / 2;
    
    // Draw track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = trackStrokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, center),
      Offset(size.width, center),
      trackPaint,
    );

    // Draw animated progress lines
    _drawAnimatedLine(canvas, size, center, firstLineTail, firstLineHead);
    _drawAnimatedLine(canvas, size, center, secondLineTail, secondLineHead);
  }

  void _drawAnimatedLine(Canvas canvas, Size size, double center, double tail, double head) {
    if (head <= tail) return;

    final startX = size.width * tail;
    final endX = size.width * head;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (amplitude > 0) {
      final path = Path();
      final waveAmplitude = amplitude * (size.height / 2 - strokeWidth);
      bool started = false;

      for (double x = startX; x <= endX; x += 1) {
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
        Offset(startX, center),
        Offset(endX, center),
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LinearWavyProgressIndeterminatePainter oldDelegate) {
    return oldDelegate.firstLineHead != firstLineHead ||
           oldDelegate.firstLineTail != firstLineTail ||
           oldDelegate.secondLineHead != secondLineHead ||
           oldDelegate.secondLineTail != secondLineTail ||
           oldDelegate.waveOffset != waveOffset;
  }
}