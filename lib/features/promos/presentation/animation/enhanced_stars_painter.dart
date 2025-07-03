import 'dart:math' as math;

import 'package:flutter/material.dart';

class EnhancedStarsPainter extends CustomPainter {
  final double animation;

  EnhancedStarsPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42);

    // Multiple layers of stars with different sizes and intensities
    for (int layer = 0; layer < 3; layer++) {
      final starCount = layer == 0 ? 80 : (layer == 1 ? 40 : 20);
      final baseSize = layer == 0 ? 1.0 : (layer == 1 ? 2.0 : 3.0);
      final opacity = layer == 0 ? 0.6 : (layer == 1 ? 0.8 : 1.0);

      for (int i = 0; i < starCount; i++) {
        final x = random.nextDouble() * size.width;
        final y = random.nextDouble() * size.height * 0.7;

        // Different twinkling patterns for each layer
        final twinkleSpeed = layer == 0 ? 1.0 : (layer == 1 ? 0.7 : 0.5);
        final phase = animation * twinkleSpeed * 2 * math.pi + i;
        final twinkle = (math.sin(phase) + 1) / 2;

        final starSize = baseSize + twinkle * (baseSize * 0.5);
        final starOpacity = opacity * (0.3 + twinkle * 0.7);

        paint.color = Colors.white.withOpacity(starOpacity);

        if (layer == 2 && i % 5 == 0) {
          // Some bright stars with color variations
          final colorVariation = i % 3;
          if (colorVariation == 0) {
            paint.color = const Color(
              0xFFFFE5B4,
            ).withOpacity(starOpacity); // Warm white
          } else if (colorVariation == 1) {
            paint.color = const Color(
              0xFFE5F4FF,
            ).withOpacity(starOpacity); // Cool white
          }
        }

        _drawStar(canvas, paint, Offset(x, y), starSize);
      }
    }
  }

  void _drawStar(Canvas canvas, Paint paint, Offset center, double size) {
    // Enhanced star shape with glow effect
    final glowPaint = Paint()
      ..color = paint.color.withOpacity(paint.color.opacity * 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

    // Glow effect
    canvas.drawCircle(center, size * 2, glowPaint);

    // Main star
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 144 - 90) * math.pi / 180;
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
