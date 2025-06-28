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

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
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
        case 'final_glow':
          _glowController.repeat(reverse: true);
          break;
      }
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimation,
        _rotationAnimation,
        _glowAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 2 * 3.14159,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.appPrimaryColor.withOpacity(
                      _glowAnimation.value * 0.6,
                    ),
                    blurRadius: 30 * _glowAnimation.value,
                    spreadRadius: 10 * _glowAnimation.value,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(AppConstants.viveraLogo, fit: BoxFit.cover),
              ),
            ),
          ),
        );
      },
    );
  }
}
