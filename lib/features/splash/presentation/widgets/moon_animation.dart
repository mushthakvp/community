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
    with SingleTickerProviderStateMixin {
  late AnimationController _starController;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(MoonAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _starController.repeat();
    } else if (!widget.isActive && oldWidget.isActive) {
      _starController.stop();
    }
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.animation, _starController]),
      builder: (context, child) {
        return SizedBox(
          width: 120,
          height: 120,
          child: CustomPaint(
            painter: MoonPainter(
              widget.animation.value,
              _starController.value,
              widget.isActive,
            ),
            size: const Size(120, 120),
          ),
        );
      },
    );
  }
}

class MoonPainter extends CustomPainter {
  final double moonAnimation;
  final double starAnimation;
  final bool isActive;

  MoonPainter(this.moonAnimation, this.starAnimation, this.isActive);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    if (!isActive) return;

    // Draw moon glow
    final glowPaint = Paint()
      ..color = const Color(0xFFF0F8FF).withOpacity(0.3 * moonAnimation)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawCircle(center, 30 + (5 * moonAnimation), glowPaint);

    // Draw moon
    final moonPaint = Paint()
      ..color = const Color(0xFFF0F8FF).withOpacity(0.9)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 25, moonPaint);

    // Draw moon craters
    final craterPaint = Paint()
      ..color = const Color(0xFFE6E6FA).withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(center.dx - 8, center.dy - 5), 3, craterPaint);
    canvas.drawCircle(Offset(center.dx + 6, center.dy + 8), 2, craterPaint);
    canvas.drawCircle(Offset(center.dx + 2, center.dy - 10), 1.5, craterPaint);

    // Draw moon phase shadow
    final shadowPaint = Paint()
      ..color = const Color(0xFFD3D3D3).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final shadowPath = Path();
    shadowPath.addArc(
      Rect.fromCircle(center: center, radius: 25),
      -math.pi / 2,
      math.pi,
    );
    canvas.drawPath(shadowPath, shadowPaint);

    // Draw stars around moon
    _drawStars(canvas, center, size);

    // Draw moon rays
    _drawMoonRays(canvas, center);
  }

  void _drawStars(Canvas canvas, Offset moonCenter, Size size) {
    final starPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final starPositions = [
      Offset(20, 20),
      Offset(size.width - 20, 25),
      Offset(15, size.height - 30),
      Offset(size.width - 25, size.height - 20),
      Offset(size.width / 2 - 40, 15),
      Offset(size.width / 2 + 40, size.height - 15),
    ];

    for (int i = 0; i < starPositions.length; i++) {
      final position = starPositions[i];
      final twinkle = math.sin(starAnimation * 2 * math.pi + i) * 0.5 + 0.5;
      final starSize = 1.5 + (twinkle * 1.5);

      // Draw star shape
      canvas.save();
      canvas.translate(position.dx, position.dy);

      final starPath = Path();
      for (int j = 0; j < 5; j++) {
        final angle = (j * 2 * math.pi) / 5 - math.pi / 2;
        final outerRadius = starSize;
        final innerRadius = starSize * 0.4;

        if (j == 0) {
          starPath.moveTo(
            math.cos(angle) * outerRadius,
            math.sin(angle) * outerRadius,
          );
        } else {
          starPath.lineTo(
            math.cos(angle) * outerRadius,
            math.sin(angle) * outerRadius,
          );
        }

        final innerAngle = angle + math.pi / 5;
        starPath.lineTo(
          math.cos(innerAngle) * innerRadius,
          math.sin(innerAngle) * innerRadius,
        );
      }
      starPath.close();

      canvas.drawPath(
        starPath,
        starPaint..color = Colors.white.withOpacity(0.6 + twinkle * 0.4),
      );
      canvas.restore();
    }
  }

  void _drawMoonRays(Canvas canvas, Offset center) {
    final rayPaint = Paint()
      ..color = const Color(0xFFF0F8FF).withOpacity(0.4 * moonAnimation)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2) / 8;
      final rayStart = Offset(
        center.dx + math.cos(angle) * 35,
        center.dy + math.sin(angle) * 35,
      );
      final rayEnd = Offset(
        center.dx + math.cos(angle) * 50,
        center.dy + math.sin(angle) * 50,
      );

      canvas.drawLine(rayStart, rayEnd, rayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
