import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/splash_provider.dart';
import '../widgets/animated_logo.dart';
import '../widgets/floating_particles.dart';
import '../widgets/pulsating_circle.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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

    // Initialize the splash provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SplashProvider>();
      provider.initializeApp().then((_) {
        _navigateToNextScreen();
      });
    });
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
                    radius: 1.0,
                    colors: [
                      AppConstants.appPrimaryColor.withOpacity(0.1),
                      AppConstants.black,
                      AppConstants.black,
                    ],
                    stops: const [0.0, 0.3, 1.0],
                  ),
                ),
              ),

              // Floating particles
              FloatingParticles(
                isActive:
                    provider.animationPhase == 'particles' ||
                    provider.animationPhase == 'final_glow',
              ),

              // Pulsating circles
              Center(
                child: PulsatingCircle(
                  isActive: provider.animationPhase == 'final_glow',
                ),
              ),

              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated logo
                    AnimatedLogo(animationPhase: provider.animationPhase),

                    const SizedBox(height: 40),

                    // App title with animation
                    SlideTransition(
                      position: _textSlide,
                      child: FadeTransition(
                        opacity: _textOpacity,
                        child: Column(
                          children: [
                            const CommonTextWidget(
                              text: 'കുടുംബശ്രീ',
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.appPrimaryColor,
                            ),
                            const SizedBox(height: 8),
                            CommonTextWidget(
                              text: 'Community App',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppConstants.white.withOpacity(0.8),
                            ),
                            const SizedBox(height: 4),
                            CommonTextWidget(
                              text: 'സമുദായം • ശാക്തീകരണം • വളർച്ച',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppConstants.white.withOpacity(0.6),
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
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppConstants.appPrimaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CommonTextWidget(
                            text: 'Initializing...',
                            fontSize: 12,
                            color: AppConstants.white.withOpacity(0.6),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              // Bottom branding
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _textOpacity,
                  child: Column(
                    children: [
                      CommonTextWidget(
                        text: 'Powered by',
                        fontSize: 12,
                        color: AppConstants.white.withOpacity(0.4),
                        align: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const CommonTextWidget(
                        text: 'Kudumbashree',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.appPrimaryColor,
                        align: TextAlign.center,
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
