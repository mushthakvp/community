import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class WalkingWomen extends StatefulWidget {
  final bool isActive;

  const WalkingWomen({super.key, required this.isActive});

  @override
  State<WalkingWomen> createState() => _WalkingWomenState();
}

class _WalkingWomenState extends State<WalkingWomen>
    with TickerProviderStateMixin {
  late AnimationController _walkController;
  late AnimationController _fadeController;
  final List<WomanFigure> _women = [];

  @override
  void initState() {
    super.initState();
    _walkController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _generateWomen();
  }

  void _generateWomen() {
    final random = math.Random();
    final colors = [
      AppConstants.appPrimaryColor,
      const Color(0xFFE91E63),
      const Color(0xFF9C27B0),
      const Color(0xFF3F51B5),
      const Color(0xFF009688),
    ];

    for (int i = 0; i < 5; i++) {
      _women.add(
        WomanFigure(
          startX: -0.2 - (i * 0.15),
          endX: 1.3 + (i * 0.1),
          y: 0.7 + (random.nextDouble() * 0.1),
          color: colors[i % colors.length],
          speed: 0.8 + (random.nextDouble() * 0.4),
          scale: 0.8 + (random.nextDouble() * 0.4),
          delay: i * 0.3,
        ),
      );
    }
  }

  @override
  void didUpdateWidget(WalkingWomen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _fadeController.forward();
      _walkController.repeat();
    } else if (!widget.isActive && oldWidget.isActive) {
      _fadeController.reverse();
      _walkController.stop();
    }
  }

  @override
  void dispose() {
    _walkController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_walkController, _fadeController]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeController,
          child: SizedBox(
            height: 200,
            child: CustomPaint(
              painter: WomenPainter(_women, _walkController.value),
              size: Size(MediaQuery.of(context).size.width, 200),
            ),
          ),
        );
      },
    );
  }
}

class WomanFigure {
  final double startX, endX, y;
  final Color color;
  final double speed, scale, delay;

  WomanFigure({
    required this.startX,
    required this.endX,
    required this.y,
    required this.color,
    required this.speed,
    required this.scale,
    required this.delay,
  });
}

class WomenPainter extends CustomPainter {
  final List<WomanFigure> women;
  final double animationValue;

  WomenPainter(this.women, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw ground/path
    _drawPath(canvas, size);

    // Draw women figures
    for (var woman in women) {
      _drawWoman(canvas, size, woman);
    }

    // Draw kudumbashree elements
    _drawKudumbasreeElements(canvas, size);
  }

  void _drawPath(Canvas canvas, Size size) {
    final pathPaint = Paint()
      ..color = AppConstants.appPrimaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.75,
      size.width,
      size.height * 0.8,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, pathPaint);

    // Path border
    final borderPaint = Paint()
      ..color = AppConstants.appPrimaryColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final borderPath = Path();
    borderPath.moveTo(0, size.height * 0.8);
    borderPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.75,
      size.width,
      size.height * 0.8,
    );

    canvas.drawPath(borderPath, borderPaint);
  }

  void _drawWoman(Canvas canvas, Size size, WomanFigure woman) {
    final adjustedAnimationValue = math.max(
      0.0,
      (animationValue - woman.delay).clamp(0.0, 1.0),
    );
    final currentX =
        woman.startX +
        (woman.endX - woman.startX) * adjustedAnimationValue * woman.speed;

    // Skip if woman is out of view
    if (currentX < -0.3 || currentX > 1.3) return;

    final position = Offset(currentX * size.width, woman.y * size.height);
    final walkCycle = math.sin(animationValue * 12 + woman.delay * 3) * 0.1;

    canvas.save();
    canvas.translate(position.dx, position.dy + walkCycle * 10);
    canvas.scale(woman.scale);

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 35), width: 30, height: 8),
      shadowPaint,
    );

    // Body
    final bodyPaint = Paint()
      ..color = woman.color
      ..style = PaintingStyle.fill;

    // Head
    canvas.drawCircle(const Offset(0, -25), 8, bodyPaint);

    // Hair
    final hairPaint = Paint()
      ..color = Colors.brown.shade800
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCenter(center: const Offset(0, -25), width: 20, height: 16),
      math.pi,
      math.pi,
      false,
      hairPaint,
    );

    // Body/Dress
    final dressPath = Path();
    dressPath.moveTo(-8, -15);
    dressPath.lineTo(8, -15);
    dressPath.lineTo(12, 20);
    dressPath.lineTo(-12, 20);
    dressPath.close();
    canvas.drawPath(dressPath, bodyPaint);

    // Arms with walking motion
    final armSwing = math.sin(animationValue * 8 + woman.delay * 2) * 0.3;

    // Left arm
    canvas.save();
    canvas.translate(-6, -5);
    canvas.rotate(armSwing);
    canvas.drawLine(
      const Offset(0, 0),
      const Offset(0, 15),
      Paint()
        ..color = woman.color.withOpacity(0.8)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();

    // Right arm
    canvas.save();
    canvas.translate(6, -5);
    canvas.rotate(-armSwing);
    canvas.drawLine(
      const Offset(0, 0),
      const Offset(0, 15),
      Paint()
        ..color = woman.color.withOpacity(0.8)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();

    // Legs with walking motion
    final legSwing = math.sin(animationValue * 8 + woman.delay * 2) * 0.4;

    // Left leg
    canvas.save();
    canvas.translate(-4, 20);
    canvas.rotate(legSwing);
    canvas.drawLine(
      const Offset(0, 0),
      const Offset(0, 20),
      Paint()
        ..color = woman.color.withOpacity(0.9)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();

    // Right leg
    canvas.save();
    canvas.translate(4, 20);
    canvas.rotate(-legSwing);
    canvas.drawLine(
      const Offset(0, 0),
      const Offset(0, 20),
      Paint()
        ..color = woman.color.withOpacity(0.9)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();

    // Dupatta/Scarf flowing
    final scarf = Path();
    final scarfFlow = math.sin(animationValue * 6 + woman.delay) * 5;
    scarf.moveTo(8, -15);
    scarf.quadraticBezierTo(15 + scarfFlow, -10, 20 + scarfFlow, 5);
    scarf.quadraticBezierTo(18 + scarfFlow, 8, 15 + scarfFlow, 10);
    scarf.quadraticBezierTo(10 + scarfFlow, 5, 8, -10);
    scarf.close();

    canvas.drawPath(
      scarf,
      Paint()
        ..color = woman.color.withOpacity(0.6)
        ..style = PaintingStyle.fill,
    );

    canvas.restore();
  }

  void _drawKudumbasreeElements(Canvas canvas, Size size) {
    // Draw lotus flowers (Kudumbashree symbol)
    _drawLotusFlowers(canvas, size);

    // Draw empowerment symbols
    _drawEmpowermentSymbols(canvas, size);
  }

  void _drawLotusFlowers(Canvas canvas, Size size) {
    final lotus1 = Offset(size.width * 0.1, size.height * 0.3);
    final lotus2 = Offset(size.width * 0.9, size.height * 0.2);
    final lotus3 = Offset(size.width * 0.8, size.height * 0.6);

    for (var center in [lotus1, lotus2, lotus3]) {
      _drawLotus(canvas, center);
    }
  }

  void _drawLotus(Canvas canvas, Offset center) {
    final petalPaint = Paint()
      ..color = AppConstants.appPrimaryColor.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // Draw petals
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2) / 8;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);

      final petal = Path();
      petal.moveTo(0, 0);
      petal.quadraticBezierTo(5, -10, 0, -15);
      petal.quadraticBezierTo(-5, -10, 0, 0);

      canvas.drawPath(petal, petalPaint);
      canvas.restore();
    }

    // Center
    canvas.drawCircle(
      center,
      3,
      Paint()
        ..color = AppConstants.appPrimaryColor.withOpacity(0.7)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawEmpowermentSymbols(Canvas canvas, Size size) {
    // Draw linked hands symbol
    final handsCenter = Offset(size.width * 0.2, size.height * 0.1);
    _drawLinkedHands(canvas, handsCenter);

    // Draw unity circles
    final unityCenter = Offset(size.width * 0.7, size.height * 0.1);
    _drawUnityCircles(canvas, unityCenter);
  }

  void _drawLinkedHands(Canvas canvas, Offset center) {
    final handPaint = Paint()
      ..color = AppConstants.appPrimaryColor.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw connecting hands
    for (int i = 0; i < 3; i++) {
      final x = center.dx + (i * 15);
      final y = center.dy + math.sin(animationValue * 3 + i) * 3;

      // Hand shape
      canvas.drawCircle(Offset(x, y), 4, handPaint);

      // Connection line
      if (i < 2) {
        canvas.drawLine(Offset(x + 4, y), Offset(x + 11, y), handPaint);
      }
    }
  }

  void _drawUnityCircles(Canvas canvas, Offset center) {
    final circlePaint = Paint()
      ..color = AppConstants.appPrimaryColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw overlapping circles representing unity
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi * 2) / 4;
      final radius = 8.0;
      final circleCenter = Offset(
        center.dx + math.cos(angle) * 6,
        center.dy + math.sin(angle) * 6,
      );

      canvas.drawCircle(circleCenter, radius, circlePaint);
    }

    // Center circle
    canvas.drawCircle(
      center,
      3,
      Paint()
        ..color = AppConstants.appPrimaryColor.withOpacity(0.4)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
