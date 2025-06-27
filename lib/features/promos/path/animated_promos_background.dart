import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vivera/features/promos/path/moon_painter.dart';
import 'package:vivera/features/promos/path/particles_painter.dart';
import 'package:vivera/features/promos/path/stars_painter.dart';

import '../../../core/constants/app_constants.dart';

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

  late Animation<double> _moonAnimation;
  late Animation<double> _starsAnimation;
  late Animation<double> _gradientAnimation;

  @override
  void initState() {
    super.initState();

    // Moon animation - slow circular movement
    _moonController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _moonAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _moonController, curve: Curves.linear));

    // Stars animation - twinkling effect
    _starsController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _starsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _starsController, curve: Curves.easeInOut),
    );

    // Gradient animation - subtle color shifts
    _gradientController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );

    // Start animations
    _moonController.repeat();
    _starsController.repeat(reverse: true);
    _gradientController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _moonController.dispose();
    _starsController.dispose();
    _gradientController.dispose();
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
          AnimatedBuilder(
            animation: _gradientAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(
                        const Color(0xffF0B90A),
                        const Color(0xff1a1a2e),
                        _gradientAnimation.value * 0.3,
                      )!,
                      Color.lerp(
                        const Color(0xffA52EA1),
                        const Color(0xff16213e),
                        _gradientAnimation.value * 0.4,
                      )!,
                      Color.lerp(
                        const Color(0xff000000),
                        const Color(0xff0f3460),
                        _gradientAnimation.value * 0.2,
                      )!,
                    ],
                    begin: Alignment.topLeft,
                    end: AlignmentDirectional.bottomCenter,
                  ),
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: _starsAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: StarsPainter(_starsAnimation.value),
              );
            },
          ),

          AnimatedBuilder(
            animation: _moonAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: MoonPainter(_moonAnimation.value, size),
              );
            },
          ),

          AnimatedBuilder(
            animation: _starsController,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: ParticlesPainter(_starsAnimation.value),
              );
            },
          ),

          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(AppConstants.promoseBg),
                opacity: 0.3,
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
