import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
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
      duration: const Duration(seconds: 3),
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

    // Initialize the splash provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SplashProvider>();
      provider.initializeApp().then((_) {
        // Wait for lady to complete walking animation
        provider.onWalkingComplete = () {
          _navigateToNextScreen();
        };
      });
    });

    // Start animations
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
      backgroundColor: AppConstants.black,
      body: Consumer<SplashProvider>(
        builder: (context, provider, child) {
          // Start text animation when appropriate
          if (provider.animationPhase == 'text_animation') {
            _textController.forward();
          }

          return Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.5,
                    colors: [
                      AppConstants.appPrimaryColor.withOpacity(0.15),
                      const Color(0xFF1a1a2e),
                      AppConstants.black,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // Animated background pattern
              AnimatedOpacity(
                opacity: _fadeAnimation.value,
                duration: const Duration(milliseconds: 500),
                child: CustomPaint(
                  painter: BackgroundPatternPainter(),
                  size: MediaQuery.of(context).size,
                ),
              ),

              // Moon Animation (top)
              Positioned(
                top: 50,
                right: 30,
                child: MoonAnimation(
                  isActive: provider.animationPhase != 'initial',
                  animation: _moonAnimation,
                ),
              ),

              // Marketplace Particles (floating around)
              MarketplaceParticles(
                isActive:
                    provider.animationPhase == 'marketplace_particles' ||
                    provider.animationPhase == 'women_walking' ||
                    provider.animationPhase == 'final_glow',
              ),

              // Walking Women Animation (bottom) - triggers navigation when complete
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

              // Main content with GIF logo
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // GIF Animation Logo
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppConstants.appPrimaryColor.withOpacity(
                                0.3,
                              ),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: provider.animationPhase != 'initial'
                              ? Image.asset(
                                  'assets/animation/vivera-animation.gif',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback to animated logo if GIF not found
                                    return AnimatedLogo(
                                      animationPhase: provider.animationPhase,
                                    );
                                  },
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: RadialGradient(
                                      colors: [
                                        AppConstants.appPrimaryColor
                                            .withOpacity(0.5),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // App title with animation
                      SlideTransition(
                        position: _textSlide,
                        child: FadeTransition(
                          opacity: _textOpacity,
                          child: Column(
                            children: [
                              // Livera Brand
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    AppConstants.appPrimaryColor,
                                    AppConstants.appPrimaryColor.withOpacity(
                                      0.8,
                                    ),
                                    const Color(0xFFFFD700),
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
                              CommonTextWidget(
                                text: 'Community Empowerment Platform',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppConstants.white.withOpacity(0.9),
                                letterSpacing: 1.2,
                              ),
                              const SizedBox(height: 12),
                              // Kudumbashree tagline
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppConstants.appPrimaryColor.withOpacity(
                                        0.2,
                                      ),
                                      Colors.transparent,
                                    ],
                                  ),
                                  border: Border.all(
                                    color: AppConstants.appPrimaryColor
                                        .withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: CommonTextWidget(
                                  text: 'കുടുംബശ്രീ • സമുദായം • ശാക്തീകരണം',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppConstants.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Loading indicator
                      if (provider.isLoading)
                        Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppConstants.appPrimaryColor,
                                    AppConstants.appPrimaryColor.withOpacity(
                                      0.6,
                                    ),
                                  ],
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            CommonTextWidget(
                              text: 'Initializing Platform...',
                              fontSize: 12,
                              color: AppConstants.white.withOpacity(0.7),
                              letterSpacing: 1.0,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              // Bottom branding
              Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _textOpacity,
                  child: Column(
                    children: [
                      CommonTextWidget(
                        text: 'Powered by',
                        fontSize: 12,
                        color: AppConstants.white.withOpacity(0.5),
                        align: TextAlign.center,
                        letterSpacing: 1.0,
                      ),
                      const SizedBox(height: 6),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            AppConstants.appPrimaryColor,
                            const Color(0xFFFFD700),
                          ],
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
                      CommonTextWidget(
                        text: 'Technology • Innovation • Empowerment',
                        fontSize: 10,
                        color: AppConstants.white.withOpacity(0.6),
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

class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppConstants.appPrimaryColor.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Create a geometric pattern
    final spacing = 40.0;

    // Draw diagonal lines
    for (double x = -size.height; x < size.width + size.height; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }

    // Draw reverse diagonal lines
    for (double x = 0; x < size.width + size.height; x += spacing * 2) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height, size.height),
        paint..color = AppConstants.appPrimaryColor.withOpacity(0.03),
      );
    }

    // Draw dots at intersections
    final dotPaint = Paint()
      ..color = AppConstants.appPrimaryColor.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        if ((x / spacing + y / spacing) % 2 == 0) {
          canvas.drawCircle(Offset(x, y), 1, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
