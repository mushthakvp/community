import 'dart:math' as math;

import 'package:flutter/material.dart';

class MoonPainter extends CustomPainter {
  final double animation;
  final Size screenSize;

  MoonPainter(this.animation, this.screenSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffF0B90A).withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Moon circular movement
    final centerX = screenSize.width * 0.8;
    final centerY = screenSize.height * 0.25;
    final radius = 30.0;
    final orbitRadius = 20.0;

    final moonX = centerX + math.cos(animation) * orbitRadius;
    final moonY = centerY + math.sin(animation) * orbitRadius * 0.5;

    // Moon glow effect
    final glowPaint = Paint()
      ..color = const Color(0xffF0B90A).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15.0);

    canvas.drawCircle(Offset(moonX, moonY), radius + 10, glowPaint);
    canvas.drawCircle(Offset(moonX, moonY), radius, paint);

    // Moon craters
    final craterPaint = Paint()
      ..color = const Color(0xffD4A574).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(moonX - 8, moonY - 5), 4, craterPaint);
    canvas.drawCircle(Offset(moonX + 5, moonY + 3), 3, craterPaint);
    canvas.drawCircle(Offset(moonX - 2, moonY + 8), 2, craterPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
