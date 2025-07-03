import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vivera/features/promos/presentation/animation/clouds_painter.dart';
import 'package:vivera/features/promos/presentation/animation/enhanced_moon_painter.dart';
import 'package:vivera/features/promos/presentation/animation/enhanced_particles_painter.dart';
import 'package:vivera/features/promos/presentation/animation/enhanced_stars_painter.dart';
import 'package:vivera/features/promos/presentation/animation/shooting_stars_painter.dart';

class AnimatedPromosBackground extends StatefulWidget {
  final Widget child;

  const AnimatedPromosBackground({super.key, required this.child});

  @override
  State<AnimatedPromosBackground> createState() =>
      _AnimatedPromosBackgroundState();
}

class _AnimatedPromosBackgroundState extends State<AnimatedPromosBackground>
    with TickerProviderStateMixin {
  late AnimationController _moonController;
  late AnimationController _starsController;
  late AnimationController _gradientController;
  late AnimationController _shootingStarController;
  late AnimationController _cloudController;

  late Animation<double> _moonAnimation;
  late Animation<double> _starsAnimation;
  late Animation<double> _gradientAnimation;
  late Animation<double> _shootingStarAnimation;
  late Animation<double> _cloudAnimation;

  @override
  void initState() {
    super.initState();

    // Moon animation - slow circular movement
    _moonController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    );
    _moonAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _moonController, curve: Curves.linear));

    // Stars animation - twinkling effect
    _starsController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _starsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _starsController, curve: Curves.easeInOut),
    );

    // Gradient animation - subtle color shifts for night sky
    _gradientController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    );
    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );

    // Shooting star animation
    _shootingStarController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _shootingStarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shootingStarController, curve: Curves.easeOut),
    );

    // Cloud animation - slow drift
    _cloudController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );
    _cloudAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _cloudController, curve: Curves.linear));

    // Start animations
    _moonController.repeat();
    _starsController.repeat(reverse: true);
    _gradientController.repeat(reverse: true);
    _shootingStarController.repeat();
    _cloudController.repeat();
  }

  @override
  void dispose() {
    _moonController.dispose();
    _starsController.dispose();
    _gradientController.dispose();
    _shootingStarController.dispose();
    _cloudController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        children: [
          // Base night sky gradient
          AnimatedBuilder(
            animation: _gradientAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(
                        const Color(0xff0B1426), // Deep night blue
                        const Color(0xff1a1a2e), // Darker blue
                        _gradientAnimation.value * 0.3,
                      )!,
                      Color.lerp(
                        const Color(0xff16213e), // Medium night blue
                        const Color(0xff0f3460), // Blue with hint of purple
                        _gradientAnimation.value * 0.4,
                      )!,
                      Color.lerp(
                        const Color(0xff000000), // Pure black
                        const Color(0xff0B0B0F), // Very dark blue-black
                        _gradientAnimation.value * 0.2,
                      )!,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              );
            },
          ),

          // Distant stars layer
          AnimatedBuilder(
            animation: _starsAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: EnhancedStarsPainter(_starsAnimation.value),
              );
            },
          ),

          // Shooting stars
          AnimatedBuilder(
            animation: _shootingStarAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: ShootingStarsPainter(_shootingStarAnimation.value),
              );
            },
          ),

          // Floating clouds
          AnimatedBuilder(
            animation: _cloudAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: CloudsPainter(_cloudAnimation.value),
              );
            },
          ),

          // Moon with enhanced glow
          AnimatedBuilder(
            animation: _moonAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: EnhancedMoonPainter(_moonAnimation.value, size),
              );
            },
          ),

          // Floating particles/dust
          AnimatedBuilder(
            animation: _starsController,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: EnhancedParticlesPainter(_starsAnimation.value),
              );
            },
          ),

          // Optional: Add subtle vignette effect for depth
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
              ),
            ),
          ),

          // Content
          widget.child,
        ],
      ),
    );
  }
}
