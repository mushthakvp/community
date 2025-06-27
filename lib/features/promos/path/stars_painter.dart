import 'dart:math' as math;

import 'package:flutter/material.dart';

class StarsPainter extends CustomPainter {
  final double animation;

  StarsPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Generate consistent star positions
    final random = math.Random(42); // Fixed seed for consistent positions

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * 0.6; // Upper part of screen

      // Twinkling effect
      final opacity = (math.sin(animation * 2 * math.pi + i) + 1) / 2;
      final starSize = 1.5 + opacity * 2;

      paint.color = Colors.white.withOpacity(opacity * 0.8);

      // Draw star
      _drawStar(canvas, paint, Offset(x, y), starSize);
    }
  }

  void _drawStar(Canvas canvas, Paint paint, Offset center, double size) {
    // Simple star shape using lines
    final path = Path();

    for (int i = 0; i < 5; i++) {
      final angle = (i * 144) * math.pi / 180; // 144 degrees for 5-pointed star
      final x = center.dx + math.cos(angle) * size;
      final y = center.dy + math.sin(angle) * size;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
