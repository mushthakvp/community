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
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _popController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFF45B7D1),
      const Color(0xFF96CEB4),
      const Color(0xFFFFA07A),
    ];

    for (int i = 0; i < 50; i++) {
      _particles.add(
        ConfettiParticle(
          startX: random.nextDouble(),
          startY: random.nextDouble() * 0.3 + 0.1,
          endX: random.nextDouble(),
          endY: random.nextDouble() * 0.7 + 0.3,
          size: random.nextDouble() * 6 + 3,
          rotation: random.nextDouble() * 6.28,
          rotationSpeed: random.nextDouble() * 4 - 2,
          color: colors[random.nextInt(colors.length)],
          shape: ['circle', 'square', 'triangle'][random.nextInt(3)],
          gravity: random.nextDouble() * 0.5 + 0.2,
        ),
      );
    }
  }

  void _generateBursts() {
    final random = math.Random();

    // Create multiple burst points
    for (int i = 0; i < 4; i++) {
      _bursts.add(
        PopperBurst(
          x: random.nextDouble() * 0.6 + 0.2,
          y: random.nextDouble() * 0.4 + 0.1,
          delay: i * 200.0,
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
      _controller.forward();
      _popController.forward();
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
        math.min(1.0, popValue * 4 - (burst.delay / 200)),
      );

      if (burstProgress > 0) {
        final center = Offset(burst.x * size.width, burst.y * size.height);

        // Outer explosion ring
        final outerPaint = Paint()
          ..color = AppConstants.appPrimaryColor.withOpacity(
            0.3 * (1 - burstProgress),
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4;

        canvas.drawCircle(center, burstProgress * 100, outerPaint);

        // Inner bright flash
        final innerPaint = Paint()
          ..color = Colors.white.withOpacity(0.8 * (1 - burstProgress))
          ..style = PaintingStyle.fill;

        canvas.drawCircle(center, (1 - burstProgress) * 15, innerPaint);

        // Radiating lines
        for (int i = 0; i < 8; i++) {
          final angle = (i * math.pi * 2) / 8;
          final lineEnd = Offset(
            center.dx + math.cos(angle) * burstProgress * 60,
            center.dy + math.sin(angle) * burstProgress * 60,
          );

          final linePaint = Paint()
            ..color = AppConstants.appPrimaryColor.withOpacity(
              0.6 * (1 - burstProgress),
            )
            ..strokeWidth = 2;

          canvas.drawLine(center, lineEnd, linePaint);
        }
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
