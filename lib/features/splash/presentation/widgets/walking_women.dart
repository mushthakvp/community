import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../providers/splash_provider.dart';

class WalkingWomen extends StatefulWidget {
  final bool isActive;
  final VoidCallback? onWalkingComplete;

  const WalkingWomen({
    super.key,
    required this.isActive,
    this.onWalkingComplete,
  });

  @override
  State<WalkingWomen> createState() => _WalkingWomenState();
}

class _WalkingWomenState extends State<WalkingWomen>
    with TickerProviderStateMixin {
  late AnimationController _walkController;
  late AnimationController _fadeController;
  final List<WomanFigure> _women = [];
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    _walkController = AnimationController(
      duration: const Duration(
        seconds: 6,
      ), // Reduced duration for faster completion
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _generateWomen();

    // Listen for animation completion
    _walkController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_hasCompleted) {
        _hasCompleted = true;
        // Trigger completion callback when main lady reaches the right side
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            final provider = context.read<SplashProvider>();
            provider.completeWalkingAnimation();
          }
        });
      }
    });
  }

  void _generateWomen() {
    final random = math.Random();
    final colors = [
      AppConstants.appPrimaryColor, // Main lady
      const Color(0xFFE91E63),
      const Color(0xFF9C27B0),
      const Color(0xFF3F51B5),
      const Color(0xFF009688),
    ];

    // Main lady (index 0) - she's the one who triggers navigation
    _women.add(
      WomanFigure(
        startX: -0.3,
        endX: 1.4, // Goes beyond screen to ensure completion
        y: 0.7,
        color: colors[0],
        speed: 1.0,
        scale: 1.0,
        delay: 0.0,
        isMainLady: true,
      ),
    );

    // Supporting ladies
    for (int i = 1; i < 4; i++) {
      _women.add(
        WomanFigure(
          startX: -0.2 - (i * 0.15),
          endX: 1.2 + (i * 0.1),
          y: 0.7 + (random.nextDouble() * 0.1),
          color: colors[i % colors.length],
          speed: 0.8 + (random.nextDouble() * 0.3),
          scale: 0.8 + (random.nextDouble() * 0.3),
          delay: i * 0.2,
          isMainLady: false,
        ),
      );
    }
  }

  @override
  void didUpdateWidget(WalkingWomen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _hasCompleted = false;
      _fadeController.forward();
      _walkController
          .forward(); // Use forward() instead of repeat() for one-time animation
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
  final bool isMainLady;

  WomanFigure({
    required this.startX,
    required this.endX,
    required this.y,
    required this.color,
    required this.speed,
    required this.scale,
    required this.delay,
    required this.isMainLady,
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

    // Draw empowerment elements
    _drawEmpowermentElements(canvas, size);
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

    // Path border with gradient effect
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

    // Add sparkles on the path
    _drawPathSparkles(canvas, size);
  }

  void _drawPathSparkles(Canvas canvas, Size size) {
    final sparklePaint = Paint()
      ..color = AppConstants.appPrimaryColor.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final x = (i / 7) * size.width;
      final y = size.height * 0.8 + math.sin(animationValue * 4 + i) * 5;
      final sparkleSize = 1 + math.sin(animationValue * 6 + i * 2) * 1;

      canvas.drawCircle(Offset(x, y), sparkleSize, sparklePaint);
    }
  }

  void _drawWoman(Canvas canvas, Size size, WomanFigure woman) {
    final adjustedAnimationValue = math.max(
      0.0,
      (animationValue - woman.delay).clamp(0.0, 1.0),
    );

    final currentX =
        woman.startX +
        (woman.endX - woman.startX) * adjustedAnimationValue * woman.speed;

    // Don't draw if woman hasn't started or is too far off screen
    if (adjustedAnimationValue <= 0 || currentX > 1.5) return;

    final position = Offset(currentX * size.width, woman.y * size.height);
    final walkCycle = math.sin(animationValue * 12 + woman.delay * 3) * 0.1;

    canvas.save();
    canvas.translate(position.dx, position.dy + walkCycle * 10);
    canvas.scale(woman.scale);

    // Enhanced shadow for main lady
    final shadowOpacity = woman.isMainLady ? 0.3 : 0.2;
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(shadowOpacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 35), width: 30, height: 8),
      shadowPaint,
    );

    // Body with enhanced colors for main lady
    final bodyColor = woman.isMainLady
        ? woman.color.withOpacity(1.0)
        : woman.color.withOpacity(0.9);

    final bodyPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    // Head
    canvas.drawCircle(const Offset(0, -25), 8, bodyPaint);

    // Hair with traditional style
    final hairPaint = Paint()
      ..color = Colors.brown.shade800
      ..style = PaintingStyle.fill;

    // Traditional hair bun
    canvas.drawCircle(const Offset(0, -30), 6, hairPaint);
    canvas.drawArc(
      Rect.fromCenter(center: const Offset(0, -25), width: 20, height: 16),
      math.pi,
      math.pi,
      false,
      hairPaint,
    );

    // Traditional dress/saree
    final dressPath = Path();
    dressPath.moveTo(-10, -15);
    dressPath.lineTo(10, -15);
    dressPath.quadraticBezierTo(15, 0, 12, 20);
    dressPath.quadraticBezierTo(8, 25, -8, 25);
    dressPath.quadraticBezierTo(-15, 0, -10, -15);
    dressPath.close();
    canvas.drawPath(dressPath, bodyPaint);

    // Traditional border on dress
    final borderPaint = Paint()
      ..color = Colors.amber.withOpacity(0.8)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawPath(dressPath, borderPaint);

    // Arms with natural walking motion
    final armSwing = math.sin(animationValue * 8 + woman.delay * 2) * 0.3;

    // Left arm
    canvas.save();
    canvas.translate(-6, -5);
    canvas.rotate(armSwing);
    canvas.drawLine(
      const Offset(0, 0),
      const Offset(0, 15),
      Paint()
        ..color = bodyColor
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
        ..color = bodyColor
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
        ..color = bodyColor
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
        ..color = bodyColor
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();

    // Flowing dupatta/pallu
    final scarf = Path();
    final scarfFlow = math.sin(animationValue * 6 + woman.delay) * 8;
    scarf.moveTo(8, -15);
    scarf.quadraticBezierTo(15 + scarfFlow, -10, 22 + scarfFlow, 0);
    scarf.quadraticBezierTo(25 + scarfFlow, 5, 20 + scarfFlow, 12);
    scarf.quadraticBezierTo(15 + scarfFlow, 8, 12 + scarfFlow, 5);
    scarf.quadraticBezierTo(8 + scarfFlow, -5, 8, -10);
    scarf.close();

    canvas.drawPath(
      scarf,
      Paint()
        ..color = woman.color.withOpacity(0.7)
        ..style = PaintingStyle.fill,
    );

    // Add traditional jewelry dots (necklace)
    if (woman.isMainLady) {
      final jewelPaint = Paint()
        ..color = Colors.amber
        ..style = PaintingStyle.fill;

      for (int i = 0; i < 5; i++) {
        final x = -6 + (i * 3);
        canvas.drawCircle(Offset(x.toDouble(), -12), 1, jewelPaint);
      }
    }

    canvas.restore();
  }

  void _drawEmpowermentElements(Canvas canvas, Size size) {
    // Draw subtle lotus flowers representing growth
    _drawLotusElements(canvas, size);

    // Draw unity symbols
    _drawUnitySymbols(canvas, size);
  }

  void _drawLotusElements(Canvas canvas, Size size) {
    final lotusPositions = [
      Offset(size.width * 0.15, size.height * 0.2),
      Offset(size.width * 0.85, size.height * 0.15),
      Offset(size.width * 0.7, size.height * 0.4),
    ];

    for (var position in lotusPositions) {
      _drawSmallLotus(canvas, position);
    }
  }

  void _drawSmallLotus(Canvas canvas, Offset center) {
    final petalPaint = Paint()
      ..color = AppConstants.appPrimaryColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Simple lotus representation
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi * 2) / 6;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);

      final petal = Path();
      petal.moveTo(0, 0);
      petal.quadraticBezierTo(3, -6, 0, -8);
      petal.quadraticBezierTo(-3, -6, 0, 0);

      canvas.drawPath(petal, petalPaint);
      canvas.restore();
    }

    // Center
    canvas.drawCircle(
      center,
      2,
      Paint()
        ..color = AppConstants.appPrimaryColor.withOpacity(0.6)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawUnitySymbols(Canvas canvas, Size size) {
    // Draw connected circles representing unity and collaboration
    final unityCenter = Offset(size.width * 0.5, size.height * 0.1);

    final circlePaint = Paint()
      ..color = AppConstants.appPrimaryColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Three overlapping circles
    for (int i = 0; i < 3; i++) {
      final angle = (i * 2 * math.pi) / 3;
      final circleCenter = Offset(
        unityCenter.dx + math.cos(angle) * 8,
        unityCenter.dy + math.sin(angle) * 8,
      );

      canvas.drawCircle(circleCenter, 6, circlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
