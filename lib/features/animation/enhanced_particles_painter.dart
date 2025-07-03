import 'dart:math' as math;

import 'package:flutter/material.dart';

class EnhancedParticlesPainter extends CustomPainter {
  final double animation;

  EnhancedParticlesPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(789);

    // Cosmic dust particles
    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;

      // Gentle floating animation
      final floatOffset = math.sin(animation * 2 * math.pi + i * 0.1) * 5;
      final y = baseY + floatOffset;

      final opacity = (math.cos(animation * 2 * math.pi + i * 0.3) + 1) / 2;
      final particleSize = 0.5 + opacity * 1.0;

      // Subtle color variations
      Color particleColor;
      final colorType = i % 4;
      switch (colorType) {
        case 0:
          particleColor = Colors.white;
          break;
        case 1:
          particleColor = const Color(0xFFE5F4FF); // Cool white
          break;
        case 2:
          particleColor = const Color(0xFFFFE5B4); // Warm white
          break;
        default:
          particleColor = const Color(0xFFF0B90A); // Golden
      }

      paint.color = particleColor.withOpacity(opacity * 0.4);
      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }

    // Larger, more prominent floating orbs
    for (int i = 0; i < 8; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;

      final floatOffset = math.sin(animation * 1.5 * math.pi + i * 0.5) * 15;
      final y = baseY + floatOffset;

      final opacity = (math.cos(animation * 1.5 * math.pi + i * 0.7) + 1) / 2;
      final orbSize = 2.0 + opacity * 2.0;

      paint.color = const Color(0xFFF0B90A).withOpacity(opacity * 0.3);

      // Glow effect for orbs
      final glowPaint = Paint()
        ..color = const Color(0xFFF0B90A).withOpacity(opacity * 0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

      canvas.drawCircle(Offset(x, y), orbSize * 2, glowPaint);
      canvas.drawCircle(Offset(x, y), orbSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
