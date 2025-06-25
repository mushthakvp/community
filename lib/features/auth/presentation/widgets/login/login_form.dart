import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../../providers/auth_provider.dart';
import '../forgot_password_dialog.dart';
import '../password_field.dart';

class LoginForm extends StatefulWidget {
  final AnimationController slideController;
  final AnimationController fadeController;

  const LoginForm({
    super.key,
    required this.slideController,
    required this.fadeController,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: widget.slideController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.fadeController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Form(
          key: _formKey,
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Column(
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
              );
            },
          ),
        ),
      ),
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
              onPressed: _showForgotPasswordDialog,
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
