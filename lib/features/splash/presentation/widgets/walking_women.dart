import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      duration: const Duration(seconds: 6),
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
      const Color(0xFFFFD700), // Main lady - Gold
      const Color(0xFFFFA500), // Orange gold
      const Color(0xFFDAA520), // Golden rod
      const Color(0xFFB8860B), // Dark golden rod
      const Color(0xFFFFE135), // Bright gold yellow
    ];

    // Main lady (index 0) - she's the one who triggers navigation
    _women.add(
      WomanFigure(
        startX: -0.3,
        endX: 1.4,
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
      _walkController.forward();
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
    // Draw moonlit path
    _drawMoonlitPath(canvas, size);

    // Draw women figures
    for (var woman in women) {
      _drawWoman(canvas, size, woman);
    }

    // Draw golden empowerment elements
    _drawGoldenEmpowermentElements(canvas, size);
  }

  void _drawMoonlitPath(Canvas canvas, Size size) {
    // Dark path with golden moonlight reflections
    final pathPaint = Paint()
      ..color =
          const Color(0xFF1a1a1a) // Very dark grey, almost black
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

    // Golden moonlight reflections on path
    final moonlightPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final moonlightPath = Path();
    moonlightPath.moveTo(0, size.height * 0.8);
    moonlightPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.75,
      size.width,
      size.height * 0.8,
    );

    canvas.drawPath(moonlightPath, moonlightPaint);

    // Add golden sparkles on the path
    _drawGoldenPathSparkles(canvas, size);

    // Add moonbeam streaks across the path
    _drawMoonbeamStreaks(canvas, size);
  }

  void _drawGoldenPathSparkles(Canvas canvas, Size size) {
    final sparklePaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 12; i++) {
      final x = (i / 11) * size.width;
      final y = size.height * 0.8 + math.sin(animationValue * 4 + i) * 3;
      final sparkleIntensity = math.sin(animationValue * 6 + i * 2) * 0.5 + 0.5;

      // Different golden sparkle colors
      Color sparkleColor;
      if (i % 3 == 0) {
        sparkleColor = const Color(
          0xFFFFD700,
        ).withOpacity(0.8 * sparkleIntensity);
      } else if (i % 4 == 0) {
        sparkleColor = const Color(
          0xFFFFA500,
        ).withOpacity(0.7 * sparkleIntensity);
      } else {
        sparkleColor = const Color(
          0xFFFFE135,
        ).withOpacity(0.6 * sparkleIntensity);
      }

      sparklePaint.color = sparkleColor;

      final sparkleSize = 1.5 + sparkleIntensity * 1.5;

      // Draw star-shaped sparkles
      canvas.save();
      canvas.translate(x, y);

      for (int j = 0; j < 4; j++) {
        canvas.rotate(math.pi / 4);
        canvas.drawLine(
          Offset(-sparkleSize, 0),
          Offset(sparkleSize, 0),
          Paint()
            ..color = sparkleColor
            ..strokeWidth = 1
            ..strokeCap = StrokeCap.round,
        );
      }

      canvas.restore();
    }
  }

  void _drawMoonbeamStreaks(Canvas canvas, Size size) {
    final beamPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.1)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Diagonal moonbeam streaks
    for (int i = 0; i < 3; i++) {
      final beamPath = Path();
      final startX = (i * size.width / 4) + (size.width / 8);

      beamPath.moveTo(startX, 0);
      beamPath.lineTo(startX + 60, size.height * 0.6);
      beamPath.lineTo(startX + 80, size.height * 0.6);
      beamPath.lineTo(startX + 20, 0);
      beamPath.close();

      canvas.drawPath(beamPath, beamPaint);
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

    if (adjustedAnimationValue <= 0 || currentX > 1.5) return;

    final position = Offset(currentX * size.width, woman.y * size.height);
    final walkCycle = math.sin(animationValue * 12 + woman.delay * 3) * 0.1;

    canvas.save();
    canvas.translate(position.dx, position.dy + walkCycle * 10);
    canvas.scale(woman.scale);

    // Enhanced golden shadow for all women
    final shadowOpacity = woman.isMainLady ? 0.4 : 0.3;
    final shadowPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(shadowOpacity * 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 35), width: 35, height: 10),
      shadowPaint,
    );

    // Golden aura around main lady
    if (woman.isMainLady) {
      final auraPaint = Paint()
        ..color = const Color(0xFFFFD700).withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

      canvas.drawCircle(const Offset(0, 0), 35, auraPaint);
    }

    // Body with enhanced golden colors
    final bodyColor = woman.color;
    final bodyPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    // Head with subtle glow
    final headPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    if (woman.isMainLady) {
      headPaint.shader = RadialGradient(
        colors: [bodyColor, bodyColor.withOpacity(0.8)],
      ).createShader(Rect.fromCircle(center: const Offset(0, -25), radius: 8));
    }

    canvas.drawCircle(const Offset(0, -25), 8, headPaint);

    // Traditional hair with golden highlights
    final hairPaint = Paint()
      ..color = Colors.brown.shade900
      ..style = PaintingStyle.fill;

    // Hair bun with golden clips
    canvas.drawCircle(const Offset(0, -30), 6, hairPaint);
    canvas.drawArc(
      Rect.fromCenter(center: const Offset(0, -25), width: 20, height: 16),
      math.pi,
      math.pi,
      false,
      hairPaint,
    );

    // Golden hair accessory for main lady
    if (woman.isMainLady) {
      final accessoryPaint = Paint()
        ..color = const Color(0xFFFFD700)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(const Offset(3, -28), 2, accessoryPaint);
      canvas.drawCircle(const Offset(-3, -28), 2, accessoryPaint);
    }

    // Traditional saree with golden border
    final dressPath = Path();
    dressPath.moveTo(-10, -15);
    dressPath.lineTo(10, -15);
    dressPath.quadraticBezierTo(15, 0, 12, 20);
    dressPath.quadraticBezierTo(8, 25, -8, 25);
    dressPath.quadraticBezierTo(-15, 0, -10, -15);
    dressPath.close();

    // Saree fabric with gradient
    final dressPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [bodyColor, bodyColor.withOpacity(0.8)],
      ).createShader(dressPath.getBounds());

    canvas.drawPath(dressPath, dressPaint);

    // Elaborate golden border on saree
    final borderPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..strokeWidth = woman.isMainLady ? 2 : 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawPath(dressPath, borderPaint);

    // Golden decorative patterns on saree
    _drawSareePattern(canvas, woman);

    // Arms with natural walking motion
    final armSwing = math.sin(animationValue * 8 + woman.delay * 2) * 0.3;

    // Enhanced arm drawing with golden bangles
    _drawArmsWithBangles(canvas, bodyColor, armSwing, woman.isMainLady);

    // Legs with walking motion
    final legSwing = math.sin(animationValue * 8 + woman.delay * 2) * 0.4;

    // Enhanced leg drawing
    _drawLegsWithAnklets(canvas, bodyColor, legSwing, woman.isMainLady);

    // Flowing dupatta with golden threads
    _drawGoldenDupatta(canvas, woman);

    // Traditional jewelry
    if (woman.isMainLady) {
      _drawTraditionalJewelry(canvas);
    }

    canvas.restore();
  }

  void _drawSareePattern(Canvas canvas, WomanFigure woman) {
    final patternPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.6)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Decorative border patterns
    for (int i = 0; i < 3; i++) {
      final y = -10 + (i * 8);
      canvas.drawLine(
        Offset(-8, y.toDouble()),
        Offset(8, y.toDouble()),
        patternPaint,
      );
    }

    // Small decorative dots
    final dotPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.8)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 2; j++) {
        final x = -6 + (j * 12);
        final y = -5 + (i * 6);
        canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), 0.8, dotPaint);
      }
    }
  }

  void _drawArmsWithBangles(
    Canvas canvas,
    Color bodyColor,
    double armSwing,
    bool isMain,
  ) {
    final armPaint = Paint()
      ..color = bodyColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Left arm
    canvas.save();
    canvas.translate(-6, -5);
    canvas.rotate(armSwing);
    canvas.drawLine(const Offset(0, 0), const Offset(0, 15), armPaint);

    // Golden bangles
    if (isMain) {
      final banglePaint = Paint()
        ..color = const Color(0xFFFFD700)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(const Offset(0, 10), 2, banglePaint);
      canvas.drawCircle(const Offset(0, 12), 2, banglePaint);
    }
    canvas.restore();

    // Right arm
    canvas.save();
    canvas.translate(6, -5);
    canvas.rotate(-armSwing);
    canvas.drawLine(const Offset(0, 0), const Offset(0, 15), armPaint);

    // Golden bangles
    if (isMain) {
      final banglePaint = Paint()
        ..color = const Color(0xFFFFD700)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(const Offset(0, 10), 2, banglePaint);
      canvas.drawCircle(const Offset(0, 12), 2, banglePaint);
    }
    canvas.restore();
  }

  void _drawLegsWithAnklets(
    Canvas canvas,
    Color bodyColor,
    double legSwing,
    bool isMain,
  ) {
    final legPaint = Paint()
      ..color = bodyColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Left leg
    canvas.save();
    canvas.translate(-4, 20);
    canvas.rotate(legSwing);
    canvas.drawLine(const Offset(0, 0), const Offset(0, 20), legPaint);

    // Golden anklet
    if (isMain) {
      final ankletPaint = Paint()
        ..color = const Color(0xFFFFD700)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(const Offset(0, 18), 2.5, ankletPaint);
    }
    canvas.restore();

    // Right leg
    canvas.save();
    canvas.translate(4, 20);
    canvas.rotate(-legSwing);
    canvas.drawLine(const Offset(0, 0), const Offset(0, 20), legPaint);

    // Golden anklet
    if (isMain) {
      final ankletPaint = Paint()
        ..color = const Color(0xFFFFD700)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(const Offset(0, 18), 2.5, ankletPaint);
    }
    canvas.restore();
  }

  void _drawGoldenDupatta(Canvas canvas, WomanFigure woman) {
    final scarf = Path();
    final scarfFlow = math.sin(animationValue * 6 + woman.delay) * 8;
    scarf.moveTo(8, -15);
    scarf.quadraticBezierTo(15 + scarfFlow, -10, 22 + scarfFlow, 0);
    scarf.quadraticBezierTo(25 + scarfFlow, 5, 20 + scarfFlow, 12);
    scarf.quadraticBezierTo(15 + scarfFlow, 8, 12 + scarfFlow, 5);
    scarf.quadraticBezierTo(8 + scarfFlow, -5, 8, -10);
    scarf.close();

    // Dupatta with golden threads
    final dupattaPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          woman.color.withOpacity(0.8),
          const Color(0xFFFFD700).withOpacity(0.6),
        ],
      ).createShader(scarf.getBounds())
      ..style = PaintingStyle.fill;

    canvas.drawPath(scarf, dupattaPaint);

    // Golden border on dupatta
    final dupattaBorderPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.8)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawPath(scarf, dupattaBorderPaint);
  }

  void _drawTraditionalJewelry(Canvas canvas) {
    final jewelPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    // Elaborate necklace
    for (int i = 0; i < 7; i++) {
      final x = -9 + (i * 3);
      final y = -12 + math.sin(i * 0.5) * 1;
      canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), 1.2, jewelPaint);
    }

    // Earrings
    canvas.drawCircle(const Offset(-7, -22), 1.5, jewelPaint);
    canvas.drawCircle(const Offset(7, -22), 1.5, jewelPaint);

    // Nose ring (traditional)
    canvas.drawCircle(const Offset(1, -20), 0.8, jewelPaint);

    // Forehead jewelry (tikka)
    canvas.drawCircle(const Offset(0, -32), 1, jewelPaint);
  }

  void _drawGoldenEmpowermentElements(Canvas canvas, Size size) {
    // Draw golden lotus flowers representing growth and empowerment
    _drawGoldenLotusElements(canvas, size);

    // Draw unity symbols with golden theme
    _drawGoldenUnitySymbols(canvas, size);

    // Draw empowerment rays
    _drawEmpowermentRays(canvas, size);
  }

  void _drawGoldenLotusElements(Canvas canvas, Size size) {
    final lotusPositions = [
      Offset(size.width * 0.15, size.height * 0.2),
      Offset(size.width * 0.85, size.height * 0.15),
      Offset(size.width * 0.7, size.height * 0.4),
    ];

    for (var position in lotusPositions) {
      _drawGoldenLotus(canvas, position);
    }
  }

  void _drawGoldenLotus(Canvas canvas, Offset center) {
    // Outer petals
    final outerPetalPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.4)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2) / 8;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);

      final petal = Path();
      petal.moveTo(0, 0);
      petal.quadraticBezierTo(4, -8, 0, -10);
      petal.quadraticBezierTo(-4, -8, 0, 0);

      canvas.drawPath(petal, outerPetalPaint);
      canvas.restore();
    }

    // Inner petals
    final innerPetalPaint = Paint()
      ..color = const Color(0xFFFFA500).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi * 2) / 6 + (math.pi / 6);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);

      final petal = Path();
      petal.moveTo(0, 0);
      petal.quadraticBezierTo(2.5, -5, 0, -6);
      petal.quadraticBezierTo(-2.5, -5, 0, 0);

      canvas.drawPath(petal, innerPetalPaint);
      canvas.restore();
    }

    // Golden center
    canvas.drawCircle(
      center,
      2.5,
      Paint()
        ..color = const Color(0xFFFFD700)
        ..style = PaintingStyle.fill,
    );

    // Center highlight
    canvas.drawCircle(
      center,
      1,
      Paint()
        ..color = const Color(0xFFFFF8DC)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawGoldenUnitySymbols(Canvas canvas, Size size) {
    final unityCenter = Offset(size.width * 0.5, size.height * 0.1);

    final circlePaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Three interlocking circles representing unity
    for (int i = 0; i < 3; i++) {
      final angle = (i * 2 * math.pi) / 3;
      final circleCenter = Offset(
        unityCenter.dx + math.cos(angle) * 10,
        unityCenter.dy + math.sin(angle) * 10,
      );

      canvas.drawCircle(circleCenter, 8, circlePaint);
    }

    // Central connecting point
    canvas.drawCircle(
      unityCenter,
      3,
      Paint()
        ..color = const Color(0xFFFFD700).withOpacity(0.8)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawEmpowermentRays(Canvas canvas, Size size) {
    final rayPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.2)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    final centerX = size.width * 0.5;
    final rayCount = 12;

    for (int i = 0; i < rayCount; i++) {
      final angle = (i * 2 * math.pi) / rayCount;
      final rayLength = 40 + (math.sin(animationValue * 4 + i) * 20);

      final startX = centerX + math.cos(angle) * 20;
      final startY = size.height * 0.6 + math.sin(angle) * 20;

      final endX = centerX + math.cos(angle) * rayLength;
      final endY = size.height * 0.6 + math.sin(angle) * rayLength;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), rayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
