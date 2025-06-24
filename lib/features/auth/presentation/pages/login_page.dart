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
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/inputs/text_field.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/auth_provider.dart';
import '../widgets/password_field.dart';
import '../widgets/social_login_buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().clearError();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Sign In', showBackButton: false),
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
              const SizedBox(height: 40),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildEmailField(authProvider),
              const SizedBox(height: 20),
              _buildPasswordField(authProvider),
              const SizedBox(height: 16),
              _buildForgotPasswordButton(),
              const SizedBox(height: 32),
              _buildLoginButton(authProvider),
              const SizedBox(height: 24),
              _buildDivider(),
              const SizedBox(height: 24),
              const SocialLoginButtons(),
              const SizedBox(height: 32),
              _buildSignUpPrompt(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppConstants.appPrimaryColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_outline,
            size: 40,
            color: AppConstants.appPrimaryColor,
          ),
        ),
        const SizedBox(height: 24),
        const CommonTextWidget(
          text: 'Welcome Back!',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppConstants.white,
          align: TextAlign.center,
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: 'Sign in to access your account',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.7),
          align: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField(AuthProvider authProvider) {
    return CommonTextField(
      controller: authProvider.emailController,
      hintText: 'Email address',
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email_outlined, color: AppConstants.white),
      validator: Validators.email,
    );
  }

  Widget _buildPasswordField(AuthProvider authProvider) {
    return PasswordField(
      controller: authProvider.passwordController,
      hintText: 'Password',
      isVisible: authProvider.isPasswordVisible,
      onToggleVisibility: authProvider.togglePasswordVisibility,
      validator: (value) => Validators.required(value, 'password'),
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
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
    );
  }

  Widget _buildLoginButton(AuthProvider authProvider) {
    return PrimaryButton(
      text: 'Sign In',
      onPressed: () => _handleLogin(authProvider),
      isLoading: authProvider.isLoading,
      height: 56,
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppConstants.white.withOpacity(0.3))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CommonTextWidget(
            text: 'OR',
            fontSize: 14,
            color: AppConstants.white.withOpacity(0.6),
          ),
        ),
        Expanded(child: Divider(color: AppConstants.white.withOpacity(0.3))),
      ],
    );
  }

  Widget _buildSignUpPrompt() {
    return Row(
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
            color: AppConstants.appPrimaryColor,
          ),
        ),
      ],
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
