import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../../../promos/presentation/animation/animated_promos_background.dart';
import '../providers/auth_provider.dart';
import '../widgets/login/login_form.dart';
import '../widgets/login/login_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scrollController;

  @override
  void initState() {
    super.initState();
    _initAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        debugPrint('Requesting permission...');
        await Permission.photos.request();
      } catch (e) {
        debugPrint('Error requesting permission: $e');
      }
      context.read<AuthProvider>().clearError();
    });
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scrollController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeController.forward();
    _slideController.forward();
    _scrollController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: AnimatedPromosBackground(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            _handleAuthStateChanges(authProvider);
            if (authProvider.isLoading) {
              return const Center(
                child: LoadingWidget(message: 'Signing you in...'),
              );
            }
            return _buildContent(authProvider);
          },
        ),
      ),
    );
  }

  Widget _buildContent(AuthProvider authProvider) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                LoginHeader(
                  fadeController: _fadeController,
                  slideController: _slideController,
                  scrollController: _scrollController,
                ),
                const SizedBox(height: 40),
                LoginForm(
                  slideController: _slideController,
                  fadeController: _fadeController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleAuthStateChanges(AuthProvider authProvider) {
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
          AuthFailure(message: authProvider.errorMessage ?? "Login failed"),
        );
      }
    });
  }
}
