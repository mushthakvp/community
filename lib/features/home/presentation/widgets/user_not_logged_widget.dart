// lib/features/home/presentation/widgets/user_not_logged_widget.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/size_box.dart';
import '../../../../core/widgets/common_button.dart';
import '../../../../core/widgets/common_text_widget.dart';

class UserNotLoggedWidget extends StatefulWidget {
  final bool isArrowEnabled;
  final String? title;
  final String? subtitle;
  final String? description;
  final VoidCallback? onLoginPressed;
  final VoidCallback? onSignUpPressed;
  final VoidCallback? onBackPressed;

  const UserNotLoggedWidget({
    super.key,
    this.isArrowEnabled = false,
    this.title,
    this.subtitle,
    this.description,
    this.onLoginPressed,
    this.onSignUpPressed,
    this.onBackPressed,
  });

  @override
  State<UserNotLoggedWidget> createState() => _UserNotLoggedWidgetState();
}

class _UserNotLoggedWidgetState extends State<UserNotLoggedWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: SafeArea(
        child: Column(
          children: [
            if (widget.isArrowEnabled) _buildAppBar(),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onBackPressed ?? () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConstants.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: AppConstants.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizeBoxH(10),
          _buildIllustration(),
          const SizeBoxH(40),
          _buildTextContent(),
          const SizeBoxH(50),
          _buildActionButtons(),
          const SizeBoxH(30),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: Responsive.width * 60,
      height: Responsive.width * 60,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            AppConstants.appPrimaryColor.withOpacity(0.3),
            AppConstants.appPrimaryColor.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(child: _buildAnimatedIcon()),
    );
  }

  Widget _buildAnimatedIcon() {
    // Try to use Lottie animation if available, fallback to regular icon
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppConstants.appPrimaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppConstants.appPrimaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 60,
              color: AppConstants.appPrimaryColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextContent() {
    return Column(
      children: [
        CommonTextWidget(
          text: widget.title ?? 'Welcome!',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppConstants.white,
          align: TextAlign.center,
        ),
        const SizeBoxH(12),
        CommonTextWidget(
          text: widget.subtitle ?? 'Please sign in to continue',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppConstants.appPrimaryColor,
          align: TextAlign.center,
        ),
        const SizeBoxH(16),
        CommonTextWidget(
          text:
              widget.description ??
              'Access exclusive coupons, personalized offers, and track your savings. Join thousands of users who are already saving money!',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.8),
          align: TextAlign.center,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildLoginButton(),
        const SizeBoxH(16),
        _buildSignUpButton(),
        const SizeBoxH(24),
        _buildGuestContinueButton(),
      ],
    );
  }

  Widget _buildLoginButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: CommonButton(
            text: 'Sign In',
            onTap: widget.onLoginPressed ?? _handleLogin,
            bgColor: AppConstants.appPrimaryColor,
            textColor: AppConstants.black,
            borderRadius: BorderRadius.circular(16),
            height: 56,
            width: double.infinity,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            prefix: const Icon(
              Icons.login_rounded,
              color: AppConstants.black,
              size: 20,
            ),
            boxShadow: [
              BoxShadow(
                color: AppConstants.appPrimaryColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSignUpButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: CommonButton(
            text: 'Create Account',
            onTap: widget.onSignUpPressed ?? _handleSignUp,
            bgColor: Colors.transparent,
            borderColor: AppConstants.appPrimaryColor,
            textColor: AppConstants.appPrimaryColor,
            borderRadius: BorderRadius.circular(16),
            height: 56,
            width: double.infinity,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            borderWidth: 2,
            prefix: const Icon(
              Icons.person_add_rounded,
              color: AppConstants.appPrimaryColor,
              size: 20,
            ),
          ),
        );
      },
    );
  }

  Widget _buildGuestContinueButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: TextButton(
            onPressed: _handleGuestContinue,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonTextWidget(
                  text: 'Continue as Guest',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.white.withOpacity(0.7),
                ),
                const SizeBoxV(8),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: AppConstants.white.withOpacity(0.7),
                  size: 18,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleLogin() {
    // Navigate to login page or show login modal
    // Example: context.go('/login');
    debugPrint('Navigate to login');
  }

  void _handleSignUp() {
    // Navigate to sign up page or show sign up modal
    // Example: context.go('/signup');
    debugPrint('Navigate to sign up');
  }

  void _handleGuestContinue() {
    // Continue as guest - maybe set a flag in shared preferences
    // Example: AppPref.setGuestMode(true);
    context.pop();
    debugPrint('Continue as guest');
  }
}
