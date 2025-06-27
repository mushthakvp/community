import 'dart:math' as math;

import 'package:flutter/material.dart';

class CloudsPainter extends CustomPainter {
  final double animation;

  CloudsPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final random = math.Random(456);

    // Draw a few wispy clouds
    for (int i = 0; i < 3; i++) {
      final baseX = size.width * random.nextDouble();
      final baseY = size.height * (0.2 + random.nextDouble() * 0.4);

      // Slow horizontal drift
      final driftX = (animation * size.width * 0.1) % (size.width + 100);
      final cloudX = (baseX + driftX) % (size.width + 100) - 50;

      _drawCloud(
        canvas,
        paint,
        Offset(cloudX, baseY),
        40 + random.nextDouble() * 30,
      );
    }
  }

  void _drawCloud(Canvas canvas, Paint paint, Offset center, double size) {
    final circles = [
      Offset(center.dx - size * 0.3, center.dy),
      Offset(center.dx, center.dy - size * 0.2),
      Offset(center.dx + size * 0.2, center.dy),
      Offset(center.dx + size * 0.4, center.dy + size * 0.1),
      Offset(center.dx - size * 0.1, center.dy + size * 0.1),
    ];

    for (final circle in circles) {
      canvas.drawCircle(circle, size * 0.3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
