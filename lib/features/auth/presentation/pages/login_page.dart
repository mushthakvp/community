// lib/features/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/inputs/text_field.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/auth_provider.dart';
import '../widgets/forgot_password_dialog.dart';
import '../widgets/password_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Start animations
    _fadeAnimationController.forward();
    _slideAnimationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().clearError();
    });
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Handle authentication state changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (authProvider.isAuthenticated) {
              context.go(RouteConstants.home);
            } else if (authProvider.isOtpRequired) {
              context.go(
                '${RouteConstants.otpVerification}?email=${authProvider.emailController.text}&isLogin=true',
              );
            } else if (authProvider.hasError) {
              ErrorHandler.showError(
                context,
                UnknownFailure(message: authProvider.errorMessage!),
              );
            }
          });

          if (authProvider.isLoading) {
            return const Center(
              child: LoadingWidget(message: 'Signing you in...'),
            );
          }

          return _buildLoginForm(authProvider);
        },
      ),
    );
  }

  Widget _buildLoginForm(AuthProvider authProvider) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildAnimatedHeader(),
              const SizedBox(height: 40),
              _buildAnimatedForm(authProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: _buildHeader()),
    );
  }

  Widget _buildAnimatedForm(AuthProvider authProvider) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _slideAnimationController,
              curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
            ),
          ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _fadeAnimationController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildEmailField(authProvider),
            const SizedBox(height: 20),
            _buildPasswordField(authProvider),
            const SizedBox(height: 12),
            _buildForgotPasswordButton(),
            const SizedBox(height: 12),
            _buildLoginButton(authProvider),
            const SizedBox(height: 32),
            _buildSignUpPrompt(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
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
        ),
        const SizedBox(height: 24),

        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppConstants.appPrimaryColor, Color(0xFF00D4AA)],
          ).createShader(bounds),
          child: const CommonTextWidget(
            text: 'Welcome to Vivera Community',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            align: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),

        TweenAnimationBuilder<int>(
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
        ),
      ],
    );
  }

  Widget _buildEmailField(AuthProvider authProvider) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: CommonTextField(
            controller: authProvider.emailController,
            hintText: 'Email address',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppConstants.white,
            ),
            validator: Validators.email,
          ),
        );
      },
    );
  }

  Widget _buildPasswordField(AuthProvider authProvider) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: PasswordField(
            controller: authProvider.passwordController,
            hintText: 'Password',
            isVisible: authProvider.isPasswordVisible,
            onToggleVisibility: authProvider.togglePasswordVisibility,
            validator: (value) => Validators.required(value, 'password'),
          ),
        );
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showForgotPasswordDialog(),
              child: const CommonTextWidget(
                text: 'Forgot Password?',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppConstants.appPrimaryColor,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginButton(AuthProvider authProvider) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1400),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.bounceOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.appPrimaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: PrimaryButton(
              text: 'Sign In',
              onPressed: () => _handleLogin(authProvider),
              isLoading: authProvider.isLoading,
              height: 56,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignUpPrompt() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1600),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonTextWidget(
                text: "Don't have an account? ",
                fontSize: 14,
                color: AppConstants.white.withOpacity(0.7),
              ),
              TextButton(
                onPressed: () => context.go(RouteConstants.register),
                child: const CommonTextWidget(
                  text: 'Sign Up',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleLogin(AuthProvider authProvider) {
    if (_formKey.currentState!.validate()) {
      authProvider.login();
    }
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => const ForgotPasswordDialog(),
    );
  }
}
