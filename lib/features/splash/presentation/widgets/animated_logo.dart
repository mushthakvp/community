import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class AnimatedLogo extends StatefulWidget {
  final String animationPhase;

  const AnimatedLogo({super.key, required this.animationPhase});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _glowController;
  late AnimationController _pulseController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(AnimatedLogo oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.animationPhase != oldWidget.animationPhase) {
      switch (widget.animationPhase) {
        case 'logo_entrance':
          _scaleController.forward();
          break;
        case 'text_animation':
          _rotationController.forward();
          break;
        case 'poppers':
          _glowController.forward();
          break;
        case 'final_glow':
          _glowController.repeat(reverse: true);
          _pulseController.repeat(reverse: true);
          break;
      }
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimation,
        _rotationAnimation,
        _glowAnimation,
        _pulseAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * _pulseAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 0.5,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppConstants.appPrimaryColor.withOpacity(0.8),
                    AppConstants.appPrimaryColor.withOpacity(0.4),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.appPrimaryColor.withOpacity(
                      _glowAnimation.value * 0.8,
                    ),
                    blurRadius: 40 * _glowAnimation.value,
                    spreadRadius: 15 * _glowAnimation.value,
                  ),
                  BoxShadow(
                    color: const Color(
                      0xFFFFD700,
                    ).withOpacity(_glowAnimation.value * 0.4),
                    blurRadius: 60 * _glowAnimation.value,
                    spreadRadius: 20 * _glowAnimation.value,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppConstants.appPrimaryColor.withOpacity(0.6),
                    width: 2,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.transparent,
                      AppConstants.appPrimaryColor.withOpacity(0.1),
                    ],
                  ),
                ),
                child: ClipOval(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          AppConstants.appPrimaryColor.withOpacity(0.9),
                          AppConstants.appPrimaryColor.withOpacity(0.6),
                          AppConstants.appPrimaryColor.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Center(child: _buildLiveraIcon()),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLiveraIcon() {
    // Custom Livera icon/logo
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(
        painter: LiveraLogoPainter(_glowAnimation.value),
        size: const Size(80, 80),
      ),
    );
  }
}

class LiveraLogoPainter extends CustomPainter {
  final double glowValue;

  LiveraLogoPainter(this.glowValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Main 'L' shape
    final lPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw stylized 'L'
    final lPath = Path();
    lPath.moveTo(center.dx - 20, center.dy - 25);
    lPath.lineTo(center.dx - 20, center.dy + 15);
    lPath.lineTo(center.dx + 10, center.dy + 15);

    canvas.drawPath(lPath, lPaint);

    // Tech circuit pattern overlay
    final circuitPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.7 * glowValue)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw circuit lines
    canvas.drawLine(
      Offset(center.dx - 15, center.dy - 10),
      Offset(center.dx + 5, center.dy - 10),
      circuitPaint,
    );

    canvas.drawLine(
      Offset(center.dx - 5, center.dy - 10),
      Offset(center.dx - 5, center.dy),
      circuitPaint,
    );

    // Connection nodes
    final nodePaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.8)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(center.dx - 15, center.dy - 10), 2, nodePaint);
    canvas.drawCircle(Offset(center.dx - 5, center.dy - 10), 2, nodePaint);
    canvas.drawCircle(Offset(center.dx - 5, center.dy), 2, nodePaint);

    // Livera dot pattern
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(center.dx + 15, center.dy - 15 + (i * 10)),
        1.5,
        dotPaint,
      );
    }

    // Glow effect for final phase
    if (glowValue > 0.5) {
      final glowPaint = Paint()
        ..color = AppConstants.appPrimaryColor.withOpacity(0.3 * glowValue)
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawPath(lPath, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
