import 'dart:math' as math;

import 'package:flutter/material.dart';

class ParticlesPainter extends CustomPainter {
  final double animation;

  ParticlesPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final random = math.Random(123); // Fixed seed

    // Floating particles
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;

      // Floating animation
      final y = baseY + math.sin(animation * 2 * math.pi + i) * 10;
      final opacity = (math.cos(animation * 2 * math.pi + i * 0.5) + 1) / 2;
      final particleSize = 1.0 + opacity * 1.5;

      paint.color = Color.lerp(
        const Color(0xffF0B90A),
        const Color(0xffA52EA1),
        (i % 3) / 2,
      )!.withOpacity(opacity * 0.6);

      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
