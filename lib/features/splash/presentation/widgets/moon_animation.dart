import 'dart:math' as math;

import 'package:flutter/material.dart';

class MoonAnimation extends StatefulWidget {
  final bool isActive;
  final Animation<double> animation;

  const MoonAnimation({
    super.key,
    required this.isActive,
    required this.animation,
  });

  @override
  State<MoonAnimation> createState() => _MoonAnimationState();
}

class _MoonAnimationState extends State<MoonAnimation>
    with TickerProviderStateMixin {
  late AnimationController _starController;
  late AnimationController _glowController;
  late AnimationController _cloudController;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _cloudController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(MoonAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _starController.repeat();
      _glowController.repeat(reverse: true);
      _cloudController.repeat();
    } else if (!widget.isActive && oldWidget.isActive) {
      _starController.stop();
      _glowController.stop();
      _cloudController.stop();
    }
  }

  @override
  void dispose() {
    _starController.dispose();
    _glowController.dispose();
    _cloudController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.animation,
        _starController,
        _glowController,
        _cloudController,
      ]),
      builder: (context, child) {
        return SizedBox(
          width: 150,
          height: 150,
          child: CustomPaint(
            painter: EnhancedMoonPainter(
              widget.animation.value,
              _starController.value,
              _glowController.value,
              _cloudController.value,
              widget.isActive,
            ),
            size: const Size(150, 150),
          ),
        );
      },
    );
  }
}

class EnhancedMoonPainter extends CustomPainter {
  final double moonAnimation;
  final double starAnimation;
  final double glowAnimation;
  final double cloudAnimation;
  final bool isActive;

  EnhancedMoonPainter(
    this.moonAnimation,
    this.starAnimation,
    this.glowAnimation,
    this.cloudAnimation,
    this.isActive,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    if (!isActive) return;

    // Calculate moon brightness (bright and dim phases)
    final brightness = (math.sin(glowAnimation * 2 * math.pi) * 0.4 + 0.6)
        .clamp(0.3, 1.0);
    final glowIntensity = (math.sin(glowAnimation * 2 * math.pi) * 0.5 + 0.5);

    // Draw distant glow (atmospheric effect)
    _drawAtmosphericGlow(canvas, center, brightness, glowIntensity);

    // Draw main moon glow layers
    _drawMoonGlowLayers(canvas, center, brightness, glowIntensity);

    // Draw the moon surface
    _drawMoonSurface(canvas, center, brightness);

    // Draw moon craters and surface details
    _drawMoonSurfaceDetails(canvas, center, brightness);

    // Draw moon rays during bright phases
    if (brightness > 0.7) {
      _drawMoonRays(canvas, center, brightness);
    }

    // Draw surrounding stars with twinkling effect
    _drawTwinklingStars(canvas, center, size);

    // Draw passing clouds for realistic night sky effect
    _drawPassingClouds(canvas, size);

    // Draw moon halo during peak brightness
    if (glowIntensity > 0.8) {
      _drawMoonHalo(canvas, center, glowIntensity);
    }
  }

  void _drawAtmosphericGlow(
    Canvas canvas,
    Offset center,
    double brightness,
    double glowIntensity,
  ) {
    // Outer atmospheric glow
    final atmosphericGlow = Paint()
      ..color = const Color(
        0xFFFFD700,
      ).withOpacity(0.1 * brightness * glowIntensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);

    canvas.drawCircle(center, 65 + (glowIntensity * 10), atmosphericGlow);

    // Secondary atmospheric layer
    final secondaryGlow = Paint()
      ..color = const Color(
        0xFFFFF8DC,
      ).withOpacity(0.15 * brightness * glowIntensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 35);

    canvas.drawCircle(center, 55 + (glowIntensity * 8), secondaryGlow);
  }

  void _drawMoonGlowLayers(
    Canvas canvas,
    Offset center,
    double brightness,
    double glowIntensity,
  ) {
    // Primary moon glow (bright yellow/gold)
    final primaryGlow = Paint()
      ..color = Color.lerp(
        const Color(0xFFFFF8DC), // Cream
        const Color(0xFFFFD700), // Gold
        glowIntensity,
      )!.withOpacity(0.4 * brightness)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawCircle(center, 40 + (glowIntensity * 8), primaryGlow);

    // Secondary glow layer
    final secondaryGlow = Paint()
      ..color = const Color(
        0xFFFFE135,
      ).withOpacity(0.3 * brightness * glowIntensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawCircle(center, 35 + (glowIntensity * 5), secondaryGlow);

    // Inner bright core
    final coreGlow = Paint()
      ..color = const Color(0xFFFFFACD).withOpacity(0.6 * brightness)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(center, 25 + (glowIntensity * 3), coreGlow);
  }

  void _drawMoonSurface(Canvas canvas, Offset center, double brightness) {
    // Main moon body with realistic coloring
    final moonBody = Paint()
      ..color = Color.lerp(
        const Color(0xFFF5F5DC), // Beige (dim)
        const Color(0xFFFFFAF0), // Floral white (bright)
        brightness,
      )!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 25, moonBody);

    // Moon surface gradient for 3D effect
    final surfaceGradient = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3), // Light source from top-left
        colors: [
          Colors.white.withOpacity(0.3 * brightness),
          Colors.transparent,
          Colors.black.withOpacity(0.15),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: 25));

    canvas.drawCircle(center, 25, surfaceGradient);
  }

  void _drawMoonSurfaceDetails(
    Canvas canvas,
    Offset center,
    double brightness,
  ) {
    // Moon craters with varying opacity based on brightness
    final craterPaint = Paint()
      ..color = const Color(0xFFE6E6FA).withOpacity(0.4 + (brightness * 0.3))
      ..style = PaintingStyle.fill;

    // Large crater
    canvas.drawCircle(Offset(center.dx - 8, center.dy - 5), 4, craterPaint);

    // Medium craters
    canvas.drawCircle(Offset(center.dx + 6, center.dy + 8), 3, craterPaint);
    canvas.drawCircle(Offset(center.dx + 2, center.dy - 10), 2.5, craterPaint);

    // Small craters
    canvas.drawCircle(Offset(center.dx - 12, center.dy + 3), 1.5, craterPaint);
    canvas.drawCircle(Offset(center.dx + 10, center.dy - 2), 1.8, craterPaint);
    canvas.drawCircle(Offset(center.dx - 3, center.dy + 12), 2, craterPaint);

    // Mare (lunar seas) - darker areas
    final marePaint = Paint()
      ..color = const Color(0xFFD3D3D3).withOpacity(0.3 + (brightness * 0.2))
      ..style = PaintingStyle.fill;

    // Large mare area
    final marePath = Path();
    marePath.addOval(
      Rect.fromCenter(
        center: Offset(center.dx + 5, center.dy - 3),
        width: 12,
        height: 8,
      ),
    );
    canvas.drawPath(marePath, marePaint);

    // Smaller mare
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - 7, center.dy + 8),
        width: 8,
        height: 6,
      ),
      marePaint,
    );
  }

  void _drawMoonRays(Canvas canvas, Offset center, double brightness) {
    final rayPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.6 * brightness)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw rays extending from moon
    for (int i = 0; i < 12; i++) {
      final angle = (i * math.pi * 2) / 12;
      final rayStart = Offset(
        center.dx + math.cos(angle) * 30,
        center.dy + math.sin(angle) * 30,
      );

      // Vary ray lengths for natural look
      final lengthMultiplier = 0.7 + (math.sin(i * 1.7) * 0.3);
      final rayEnd = Offset(
        center.dx +
            math.cos(angle) * (45 + (brightness * 10)) * lengthMultiplier,
        center.dy +
            math.sin(angle) * (45 + (brightness * 10)) * lengthMultiplier,
      );

      canvas.drawLine(rayStart, rayEnd, rayPaint);
    }
  }

  void _drawTwinklingStars(Canvas canvas, Offset moonCenter, Size size) {
    final starPositions = [
      Offset(20, 25),
      Offset(size.width - 25, 30),
      Offset(15, size.height - 40),
      Offset(size.width - 20, size.height - 35),
      Offset(size.width / 2 - 50, 20),
      Offset(size.width / 2 + 60, size.height - 25),
      Offset(35, size.height / 2),
      Offset(size.width - 40, size.height / 2 - 20),
    ];

    for (int i = 0; i < starPositions.length; i++) {
      final position = starPositions[i];

      // Skip stars too close to moon
      if ((position - moonCenter).distance < 60) continue;

      final twinkle =
          math.sin(starAnimation * 3 * math.pi + i * 1.5) * 0.5 + 0.5;
      final starSize = 1.0 + (twinkle * 1.5);

      // Different star colors
      Color starColor;
      if (i % 3 == 0) {
        starColor = const Color(
          0xFFFFD700,
        ).withOpacity(0.8 + twinkle * 0.2); // Gold
      } else if (i % 4 == 0) {
        starColor = const Color(
          0xFF87CEEB,
        ).withOpacity(0.7 + twinkle * 0.3); // Light blue
      } else {
        starColor = Colors.white.withOpacity(0.7 + twinkle * 0.3); // White
      }

      final starPaint = Paint()
        ..color = starColor
        ..style = PaintingStyle.fill;

      // Draw 4-pointed star
      canvas.save();
      canvas.translate(position.dx, position.dy);

      final starPath = Path();
      // Vertical line
      starPath.moveTo(0, -starSize * 2);
      starPath.lineTo(0, starSize * 2);
      // Horizontal line
      starPath.moveTo(-starSize * 2, 0);
      starPath.lineTo(starSize * 2, 0);

      canvas.drawPath(
        starPath,
        Paint()
          ..color = starColor
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      );

      // Central bright point
      canvas.drawCircle(Offset.zero, starSize * 0.7, starPaint);
      canvas.restore();
    }
  }

  void _drawPassingClouds(Canvas canvas, Size size) {
    // Subtle cloud wisps that occasionally pass in front of moon
    final cloudOpacity = math.sin(cloudAnimation * math.pi) * 0.3;

    if (cloudOpacity > 0.1) {
      final cloudPaint = Paint()
        ..color = const Color(0xFF2F2F2F).withOpacity(cloudOpacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      // Cloud wisp 1
      final cloud1X = (cloudAnimation * size.width * 1.5) - (size.width * 0.25);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cloud1X, size.height * 0.3),
          width: 40,
          height: 15,
        ),
        cloudPaint,
      );

      // Cloud wisp 2
      final cloud2X =
          ((cloudAnimation + 0.3) * size.width * 1.2) - (size.width * 0.1);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cloud2X, size.height * 0.7),
          width: 30,
          height: 12,
        ),
        cloudPaint,
      );
    }
  }

  void _drawMoonHalo(Canvas canvas, Offset center, double glowIntensity) {
    // Spectacular halo effect during peak brightness
    final haloPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.15 * glowIntensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // Outer halo ring
    canvas.drawCircle(center, 50 + (glowIntensity * 5), haloPaint);

    // Inner halo ring
    canvas.drawCircle(
      center,
      35 + (glowIntensity * 3),
      haloPaint..strokeWidth = 1.5,
    );

    // Halo rays - longer rays during peak brightness
    final haloRayPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.3 * glowIntensity)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 16; i++) {
      final angle = (i * math.pi * 2) / 16;
      final rayStart = Offset(
        center.dx + math.cos(angle) * 50,
        center.dy + math.sin(angle) * 50,
      );
      final rayEnd = Offset(
        center.dx + math.cos(angle) * (70 + glowIntensity * 15),
        center.dy + math.sin(angle) * (70 + glowIntensity * 15),
      );

      canvas.drawLine(rayStart, rayEnd, haloRayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
