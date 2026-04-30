import 'package:flutter/material.dart';

/// Tiny equity-curve sparkline used on provider cards.
///
/// Takes pre-normalised values in 0..1 (mock-side normalises before
/// returning). Stroke colour is positive (green) when the trajectory
/// finishes higher than it started, negative (red) otherwise. A subtle
/// fill underneath softens the line.
class SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color positive;
  final Color negative;
  final double strokeWidth;

  const SparklinePainter({
    required this.values,
    required this.positive,
    required this.negative,
    this.strokeWidth = 1.6,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final color = values.last >= values.first ? positive : negative;

    final path = Path();
    final fill = Path();
    for (var i = 0; i < values.length; i++) {
      final x = (i / (values.length - 1)) * size.width;
      // Invert Y because the canvas Y axis grows downward.
      final y = size.height - (values[i] * size.height);
      if (i == 0) {
        path.moveTo(x, y);
        fill.moveTo(x, size.height);
        fill.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fill.lineTo(x, y);
      }
    }
    fill.lineTo(size.width, size.height);
    fill.close();

    canvas.drawPath(
      fill,
      Paint()..color = color.withValues(alpha: 0.10),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(SparklinePainter old) =>
      old.values != values || old.positive != positive || old.negative != negative;
}
