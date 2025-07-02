import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class LoginHeader extends StatelessWidget {
  final AnimationController fadeController;
  final AnimationController slideController;
  final AnimationController scrollController;

  const LoginHeader({
    super.key,
    required this.fadeController,
    required this.slideController,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: fadeController, curve: Curves.easeInOut));

    final slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: slideController, curve: Curves.easeOutCubic),
        );

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Column(
          children: [
            _buildLogo(),
            const SizedBox(height: 24),
            _buildAnimatedTitle(),
            const SizedBox(height: 8),
            _buildSubtitle(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppConstants.appPrimaryColor.withOpacity(0.1),
        border: Border.all(
          color: AppConstants.appPrimaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/animation/vivera-animation.gif',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_circle,
                size: 60,
                color: AppConstants.appPrimaryColor,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedTitle() {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                AppConstants.appPrimaryColor,
                Color.lerp(
                  AppConstants.appPrimaryColor,
                  const Color(0xFF00D4AA),
                  scrollController.value,
                )!,
                const Color(0xFF00D4AA),
              ],
              stops: [0.0, scrollController.value, 1.0],
            ).createShader(bounds);
          },
          child: const CommonTextWidget(
            text: 'Welcome to Livera Community',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            align: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildSubtitle() {
    return TweenAnimationBuilder<int>(
      duration: const Duration(milliseconds: 2000),
      tween: IntTween(begin: 0, end: 32),
      builder: (context, value, child) {
        const fullText = 'Sign in to access your account';
        final displayText = fullText.substring(
          0,
          value.clamp(0, fullText.length),
        );
        return CommonTextWidget(
          text: displayText,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.7),
          align: TextAlign.center,
        );
      },
    );
  }
}
