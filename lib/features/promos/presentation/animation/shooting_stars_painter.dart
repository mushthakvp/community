import 'dart:math' as math;

import 'package:flutter/material.dart';

class ShootingStarsPainter extends CustomPainter {
  final double animation;

  ShootingStarsPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final random = math.Random(123);

    // Create 2-3 shooting stars at different times
    for (int i = 0; i < 3; i++) {
      final delay = i * 0.3;
      final adjustedAnimation = ((animation + delay) % 1.0);

      if (adjustedAnimation > 0.1 && adjustedAnimation < 0.9) {
        final startX = size.width * (0.2 + random.nextDouble() * 0.6);
        final startY = size.height * (0.1 + random.nextDouble() * 0.3);

        final progress = (adjustedAnimation - 0.1) / 0.8;
        final currentX = startX + progress * size.width * 0.4;
        final currentY = startY + progress * size.height * 0.3;

        final opacity = math.sin(progress * math.pi);

        // Shooting star trail
        final gradient = LinearGradient(
          colors: [
            Colors.white.withOpacity(opacity),
            Colors.white.withOpacity(opacity * 0.5),
            Colors.transparent,
          ],
        );

        paint.shader = gradient.createShader(
          Rect.fromPoints(
            Offset(currentX - 30, currentY - 15),
            Offset(currentX, currentY),
          ),
        );

        canvas.drawLine(
          Offset(currentX - 30, currentY - 15),
          Offset(currentX, currentY),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
