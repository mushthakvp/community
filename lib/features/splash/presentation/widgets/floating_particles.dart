import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class FloatingParticles extends StatefulWidget {
  final bool isActive;

  const FloatingParticles({super.key, required this.isActive});

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _generateParticles();
  }

  void _generateParticles() {
    final random = math.Random();
    for (int i = 0; i < 20; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 4 + 2,
          speed: random.nextDouble() * 0.5 + 0.1,
          color: [
            AppConstants.appPrimaryColor,
            AppConstants.appPrimaryColor.withOpacity(0.7),
            AppConstants.white.withOpacity(0.5),
          ][random.nextInt(3)],
        ),
      );
    }
  }

  @override
  void didUpdateWidget(FloatingParticles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(_particles, _controller.value),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

class Particle {
  double x, y, size, speed;
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(0.7)
        ..style = PaintingStyle.fill;

      final currentY = (particle.y + animationValue * particle.speed) % 1.0;
      final currentX =
          particle.x +
          math.sin(animationValue * 2 * math.pi + particle.x * 10) * 0.1;

      canvas.drawCircle(
        Offset(currentX * size.width, currentY * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
