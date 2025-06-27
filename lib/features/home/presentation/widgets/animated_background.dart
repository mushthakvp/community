import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _moonController;
  late AnimationController _starsController;
  late AnimationController _cloudController;

  late Animation<double> _moonPhaseAnimation;
  late Animation<double> _moonGlowAnimation;
  late Animation<double> _starsBlinkAnimation;
  late Animation<double> _cloudMovementAnimation;

  @override
  void initState() {
    super.initState();

    // Moon animation controller (slower cycle for phases)
    _moonController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );

    // Stars blinking animation
    _starsController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Cloud movement animation
    _cloudController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _moonPhaseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _moonController, curve: Curves.easeInOut),
    );

    _moonGlowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _moonController, curve: Curves.easeInOut),
    );

    _starsBlinkAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _starsController, curve: Curves.easeInOut),
    );

    _cloudMovementAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _cloudController, curve: Curves.linear));

    // Start animations
    _moonController.repeat();
    _starsController.repeat(reverse: true);
    _cloudController.repeat();
  }

  @override
  void dispose() {
    _moonController.dispose();
    _starsController.dispose();
    _cloudController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0A0A), // Deep space black
            Color(0xFF1A1A2E), // Dark navy
            Color(0xFF16213E), // Darker blue
            Color(0xFF0F0F23), // Almost black
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Animated stars
          AnimatedBuilder(
            animation: _starsBlinkAnimation,
            builder: (context, child) => CustomPaint(
              size: Size.infinite,
              painter: StarsPainter(_starsBlinkAnimation.value),
            ),
          ),

          // Moving clouds
          AnimatedBuilder(
            animation: _cloudMovementAnimation,
            builder: (context, child) => CustomPaint(
              size: Size.infinite,
              painter: CloudsPainter(_cloudMovementAnimation.value),
            ),
          ),

          // Animated moon with phases
          Positioned(
            top: 60,
            right: 30,
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _moonPhaseAnimation,
                _moonGlowAnimation,
              ]),
              builder: (context, child) => CustomPaint(
                size: const Size(80, 80),
                painter: MoonPainter(
                  _moonPhaseAnimation.value,
                  _moonGlowAnimation.value,
                ),
              ),
            ),
          ),

          // Additional subtle light effects
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.7, -0.3),
                  radius: 0.8,
                  colors: [
                    const Color(0xFFFFCB28).withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MoonPainter extends CustomPainter {
  final double phase;
  final double glow;

  MoonPainter(this.phase, this.glow);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;

    // Moon glow effect
    final glowPaint = Paint()
      ..color = const Color(0xFFFFCB28).withOpacity(0.3 * glow)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawCircle(center, radius + 10, glowPaint);

    // Moon base (full circle)
    final moonPaint = Paint()
      ..color = const Color(0xFFFFCB28)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, moonPaint);

    // Moon phase shadow (creates the phase effect)
    final shadowPaint = Paint()
      ..color = const Color(0xFF0A0A0A)
      ..style = PaintingStyle.fill;

    // Calculate phase position (-1 to 1, where 0 is full moon)
    final phaseValue = (phase * 4) % 4;
    double shadowOffset = 0;

    if (phaseValue <= 1) {
      // New moon to first quarter
      shadowOffset = radius * 2 * (1 - phaseValue);
    } else if (phaseValue <= 2) {
      // First quarter to full moon
      shadowOffset = -radius * 2 * (phaseValue - 1);
    } else if (phaseValue <= 3) {
      // Full moon to third quarter
      shadowOffset = -radius * 2 * (3 - phaseValue);
    } else {
      // Third quarter to new moon
      shadowOffset = radius * 2 * (phaseValue - 3);
    }

    if (shadowOffset.abs() < radius * 2) {
      final shadowCenter = Offset(center.dx + shadowOffset, center.dy);
      canvas.drawCircle(shadowCenter, radius, shadowPaint);
    }

    // Moon surface details
    final detailPaint = Paint()
      ..color = const Color(0xFFE8B732).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Add some craters
    canvas.drawCircle(Offset(center.dx - 8, center.dy - 12), 3, detailPaint);
    canvas.drawCircle(Offset(center.dx + 6, center.dy - 5), 2, detailPaint);
    canvas.drawCircle(Offset(center.dx - 3, center.dy + 8), 2.5, detailPaint);
  }

  @override
  bool shouldRepaint(covariant MoonPainter oldDelegate) {
    return oldDelegate.phase != phase || oldDelegate.glow != glow;
  }
}

class StarsPainter extends CustomPainter {
  final double opacity;

  StarsPainter(this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final dimPaint = Paint()
      ..color = Colors.white.withOpacity(opacity * 0.3)
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent star positions

    // Generate stars
    for (int i = 0; i < 150; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = random.nextDouble() * 1.5 + 0.5;

      // Some stars blink more than others
      final currentPaint = (i % 3 == 0) ? paint : dimPaint;

      canvas.drawCircle(Offset(x, y), starSize, currentPaint);

      // Add twinkling effect for some stars
      if (i % 7 == 0) {
        final twinklePaint = Paint()
          ..color = const Color(0xFFFFCB28).withOpacity(opacity * 0.6)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), starSize * 0.5, twinklePaint);
      }
    }

    // Add some constellation-like patterns
    _drawConstellation(canvas, size, paint);
  }

  void _drawConstellation(Canvas canvas, Size size, Paint paint) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(opacity * 0.2)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Simple constellation pattern
    final points = [
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.25, size.height * 0.25),
      Offset(size.width * 0.3, size.height * 0.28),
      Offset(size.width * 0.35, size.height * 0.32),
    ];

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], linePaint);
      canvas.drawCircle(points[i], 1.5, paint);
    }
    canvas.drawCircle(points.last, 1.5, paint);
  }

  @override
  bool shouldRepaint(covariant StarsPainter oldDelegate) {
    return oldDelegate.opacity != opacity;
  }
}

class CloudsPainter extends CustomPainter {
  final double movement;

  CloudsPainter(this.movement);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2A2A3E).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final path1 = Path();
    final path2 = Path();

    // Cloud 1 - moving from left to right
    final cloud1X = size.width * movement;
    _drawCloud(canvas, path1, Offset(cloud1X, size.height * 0.2), 60, paint);

    // Cloud 2 - moving slower, opposite direction
    final cloud2X = size.width * (1 - movement * 0.6);
    _drawCloud(canvas, path2, Offset(cloud2X, size.height * 0.15), 40, paint);
  }

  void _drawCloud(
    Canvas canvas,
    Path path,
    Offset center,
    double size,
    Paint paint,
  ) {
    path.reset();

    // Create cloud shape with multiple circles
    final rect1 = Rect.fromCircle(center: center, radius: size * 0.6);
    final rect2 = Rect.fromCircle(
      center: Offset(center.dx - size * 0.4, center.dy),
      radius: size * 0.4,
    );
    final rect3 = Rect.fromCircle(
      center: Offset(center.dx + size * 0.4, center.dy),
      radius: size * 0.5,
    );
    final rect4 = Rect.fromCircle(
      center: Offset(center.dx, center.dy - size * 0.3),
      radius: size * 0.3,
    );

    path.addOval(rect1);
    path.addOval(rect2);
    path.addOval(rect3);
    path.addOval(rect4);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CloudsPainter oldDelegate) {
    return oldDelegate.movement != movement;
  }
}
