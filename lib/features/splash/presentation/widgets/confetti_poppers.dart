import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class ConfettiPoppers extends StatefulWidget {
  final bool isActive;

  const ConfettiPoppers({super.key, required this.isActive});

  @override
  State<ConfettiPoppers> createState() => _ConfettiPoppersState();
}

class _ConfettiPoppersState extends State<ConfettiPoppers>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _popController;
  final List<ConfettiParticle> _particles = [];
  final List<PopperBurst> _bursts = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _popController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _generateParticles();
    _generateBursts();
  }

  void _generateParticles() {
    final random = math.Random();
    final colors = [
      AppConstants.appPrimaryColor,
      const Color(0xFFFFD700),
      const Color(0xFF4ECDC4),
      const Color(0xFF45B7D1),
    ];

    for (int i = 0; i < 25; i++) {
      _particles.add(
        ConfettiParticle(
          startX: random.nextDouble(),
          startY: random.nextDouble() * 0.4 + 0.1,
          endX: random.nextDouble(),
          endY: random.nextDouble() * 0.6 + 0.4,
          size: random.nextDouble() * 4 + 2,
          rotation: random.nextDouble() * 6.28,
          rotationSpeed: random.nextDouble() * 3 - 1.5,
          color: colors[random.nextInt(colors.length)],
          shape: ['circle', 'square'][random.nextInt(2)],
          gravity: random.nextDouble() * 0.3 + 0.1,
        ),
      );
    }
  }

  void _generateBursts() {
    final random = math.Random();

    // Create fewer, more strategic burst points
    for (int i = 0; i < 2; i++) {
      _bursts.add(
        PopperBurst(
          x: 0.3 + (i * 0.4),
          y: 0.2 + (random.nextDouble() * 0.2),
          delay: i * 150.0,
        ),
      );
    }
  }

  @override
  void didUpdateWidget(ConfettiPoppers oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.reset();
      _popController.reset();
      // Start immediately without delay
      _popController.forward();
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
      _popController.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _popController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _popController]),
      builder: (context, child) {
        return CustomPaint(
          painter: ConfettiPainter(
            _particles,
            _bursts,
            _controller.value,
            _popController.value,
          ),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

class ConfettiParticle {
  final double startX, startY, endX, endY;
  final double size, rotation, rotationSpeed, gravity;
  final Color color;
  final String shape;

  ConfettiParticle({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.shape,
    required this.gravity,
  });
}

class PopperBurst {
  final double x, y, delay;

  PopperBurst({required this.x, required this.y, required this.delay});
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final List<PopperBurst> bursts;
  final double animationValue;
  final double popValue;

  ConfettiPainter(
    this.particles,
    this.bursts,
    this.animationValue,
    this.popValue,
  );

  @override
  void paint(Canvas canvas, Size size) {
    // Draw popper bursts first
    _drawPopperBursts(canvas, size);

    // Draw confetti particles
    _drawConfetti(canvas, size);
  }

  void _drawPopperBursts(Canvas canvas, Size size) {
    for (var burst in bursts) {
      final burstProgress = math.max(
        0.0,
        math.min(1.0, popValue * 3 - (burst.delay / 200)),
      );

      if (burstProgress > 0) {
        final center = Offset(burst.x * size.width, burst.y * size.height);

        // Simplified burst effect
        final outerPaint = Paint()
          ..color = AppConstants.appPrimaryColor.withOpacity(
            0.4 * (1 - burstProgress),
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawCircle(center, burstProgress * 60, outerPaint);

        // Inner flash
        final innerPaint = Paint()
          ..color = Colors.white.withOpacity(0.6 * (1 - burstProgress))
          ..style = PaintingStyle.fill;

        canvas.drawCircle(center, (1 - burstProgress) * 8, innerPaint);
      }
    }
  }

  void _drawConfetti(Canvas canvas, Size size) {
    for (var particle in particles) {
      final progress = animationValue;

      // Calculate position with gravity effect
      final currentX =
          particle.startX + (particle.endX - particle.startX) * progress;
      final gravityEffect = particle.gravity * progress * progress;
      final currentY =
          particle.startY +
          (particle.endY - particle.startY) * progress +
          gravityEffect;

      // Skip if particle is out of bounds
      if (currentY > 1.2) continue;

      final position = Offset(currentX * size.width, currentY * size.height);
      final currentRotation =
          particle.rotation + particle.rotationSpeed * progress * 4;

      final paint = Paint()
        ..color = particle.color.withOpacity(0.8 * (1 - progress * 0.3))
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(currentRotation);

      switch (particle.shape) {
        case 'circle':
          canvas.drawCircle(Offset.zero, particle.size, paint);
          break;
        case 'square':
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size * 2,
              height: particle.size * 2,
            ),
            paint,
          );
          break;
        case 'triangle':
          final path = Path();
          path.moveTo(0, -particle.size);
          path.lineTo(-particle.size, particle.size);
          path.lineTo(particle.size, particle.size);
          path.close();
          canvas.drawPath(path, paint);
          break;
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
