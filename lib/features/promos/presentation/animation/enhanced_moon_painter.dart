import 'dart:math' as math;

import 'package:flutter/material.dart';

class EnhancedMoonPainter extends CustomPainter {
  final double animation;
  final Size screenSize;

  EnhancedMoonPainter(this.animation, this.screenSize);

  @override
  void paint(Canvas canvas, Size size) {
    final moonPaint = Paint()
      ..color = const Color(0xFFF5F5DC)
          .withOpacity(0.9) // Beige moon color
      ..style = PaintingStyle.fill;

    // Moon position with gentle movement
    final centerX = screenSize.width * 0.8;
    final centerY = screenSize.height * 0.2;
    final radius = 35.0;
    final orbitRadius = 15.0;

    final moonX = centerX + math.cos(animation) * orbitRadius;
    final moonY = centerY + math.sin(animation) * orbitRadius * 0.3;

    // Multiple glow layers for realistic moon glow
    final glowLayers = [
      {'radius': radius + 25, 'opacity': 0.1, 'blur': 20.0},
      {'radius': radius + 15, 'opacity': 0.2, 'blur': 12.0},
      {'radius': radius + 8, 'opacity': 0.3, 'blur': 6.0},
    ];

    for (final layer in glowLayers) {
      final glowPaint = Paint()
        ..color = const Color(0xFFF0B90A).withOpacity(layer['opacity']!)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, layer['blur']!);

      canvas.drawCircle(Offset(moonX, moonY), layer['radius']!, glowPaint);
    }

    // Main moon body
    canvas.drawCircle(Offset(moonX, moonY), radius, moonPaint);

    // Enhanced moon surface details
    final craterPaint = Paint()
      ..color = const Color(0xFFD4A574).withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // Multiple craters with varying sizes
    final craters = [
      {'offset': Offset(moonX - 10, moonY - 8), 'radius': 5.0},
      {'offset': Offset(moonX + 8, moonY + 5), 'radius': 3.5},
      {'offset': Offset(moonX - 3, moonY + 12), 'radius': 2.5},
      {'offset': Offset(moonX + 12, moonY - 3), 'radius': 2.0},
      {'offset': Offset(moonX - 15, moonY + 3), 'radius': 1.5},
    ];

    for (final crater in craters) {
      canvas.drawCircle(
        crater['offset']! as Offset,
        crater['radius']! as double,
        craterPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
