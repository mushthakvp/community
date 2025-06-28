import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/splash_provider.dart';
import '../widgets/animated_logo.dart';
import '../widgets/marketplace_particles.dart';
import '../widgets/moon_animation.dart';
import '../widgets/walking_women.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _textController;
  late AnimationController _fadeController;
  late AnimationController _moonController;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _fadeAnimation;
  late Animation<double> _moonAnimation;

  @override
  void initState() {
    super.initState();
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _moonController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _moonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _moonController, curve: Curves.easeInOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SplashProvider>();
      provider.initializeApp().then((_) {
        provider.onWalkingComplete = () {
          _navigateToNextScreen();
        };
      });
    });

    _fadeController.forward();
    _moonController.repeat(reverse: true);
  }

  void _navigateToNextScreen() {
    final provider = context.read<SplashProvider>();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        if (provider.isAuthenticated) {
          context.go(RouteConstants.home);
        } else {
          context.go(RouteConstants.login);
        }
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _fadeController.dispose();
    _moonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<SplashProvider>(
        builder: (context, provider, child) {
          if (provider.animationPhase == 'text_animation') {
            _textController.forward();
          }
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 2.0,
                    colors: [
                      Color(0xFF1a1a2e),
                      Color(0xFF16213e),
                      Colors.black,
                    ],
                    stops: [0.0, 0.4, 1.0],
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _fadeAnimation.value,
                duration: const Duration(milliseconds: 500),
                child: CustomPaint(
                  painter: StarfieldPatternPainter(_moonAnimation.value),
                  size: MediaQuery.of(context).size,
                ),
              ),
              Positioned(
                top: 50,
                right: 30,
                child: MoonAnimation(
                  isActive: provider.animationPhase != 'initial',
                  animation: _moonAnimation,
                ),
              ),
              MarketplaceParticles(
                isActive:
                    provider.animationPhase == 'marketplace_particles' ||
                    provider.animationPhase == 'women_walking' ||
                    provider.animationPhase == 'final_glow',
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: WalkingWomen(
                  isActive:
                      provider.animationPhase == 'women_walking' ||
                      provider.animationPhase == 'final_glow',
                  onWalkingComplete: provider.onWalkingComplete,
                ),
              ),
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: provider.animationPhase != 'initial'
                              ? Image.asset(
                                  'assets/animation/vivera-animation.gif',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return AnimatedLogo(
                                      animationPhase: provider.animationPhase,
                                    );
                                  },
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.transparent,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      SlideTransition(
                        position: _textSlide,
                        child: FadeTransition(
                          opacity: _textOpacity,
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                      colors: [
                                        Color(0xFFFFD700),
                                        Color(0xFFFFA500),
                                        Color(0xFFB8860B),
                                      ],
                                    ).createShader(bounds),
                                child: const CommonTextWidget(
                                  text: 'LIVERA',
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 3.0,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const CommonTextWidget(
                                text: 'Community Empowerment Platform',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFFFD700),
                                letterSpacing: 1.2,
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFFFD700,
                                    ).withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                child: const CommonTextWidget(
                                  text: 'കുടുംബശ്രീ • സമുദായം • ശാക്തീകരണം',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFFFD700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      if (provider.isLoading)
                        Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFFD700),
                                    Color(0xFFFFA500),
                                  ],
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const CommonTextWidget(
                              text: 'Initializing Platform...',
                              fontSize: 12,
                              color: Color(0xFFFFD700),
                              letterSpacing: 1.0,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _textOpacity,
                  child: Column(
                    children: [
                      const CommonTextWidget(
                        text: 'Powered by',
                        fontSize: 12,
                        color: Color(0xFFB8860B),
                        align: TextAlign.center,
                        letterSpacing: 1.0,
                      ),
                      const SizedBox(height: 6),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                        ).createShader(bounds),
                        child: const CommonTextWidget(
                          text: 'LIVERA INFOCOM',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          align: TextAlign.center,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const CommonTextWidget(
                        text: 'Technology • Innovation • Empowerment',
                        fontSize: 10,
                        color: Color(0xFFB8860B),
                        align: TextAlign.center,
                        letterSpacing: 1.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class StarfieldPatternPainter extends CustomPainter {
  final double animationValue;

  StarfieldPatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final starPaint = Paint()..style = PaintingStyle.fill;

    final random = Random(42);

    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final twinkle = sin(animationValue * 2 * pi + i) * 0.5 + 0.5;
      final brightness = random.nextDouble() * 0.8 + 0.2;
      Color starColor;
      if (i % 10 == 0) {
        starColor = const Color(0xFFFFD700).withOpacity(brightness * twinkle);
      } else if (i % 15 == 0) {
        starColor = const Color(
          0xFF87CEEB,
        ).withOpacity(brightness * twinkle * 0.7);
      } else {
        starColor = Colors.white.withOpacity(brightness * twinkle * 0.8);
      }

      starPaint.color = starColor;

      final starSize = random.nextDouble() * 1.5 + 0.5;
      canvas.drawCircle(Offset(x, y), starSize * twinkle, starPaint);
    }

    final constellationPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.3 * animationValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 5; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height * 0.6;
      final endX = startX + (random.nextDouble() - 0.5) * 100;
      final endY = startY + (random.nextDouble() - 0.5) * 50;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        constellationPaint,
      );
    }

    // Add subtle nebula clouds
    final nebulaPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.05 * animationValue)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    for (int i = 0; i < 3; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 80, nebulaPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
