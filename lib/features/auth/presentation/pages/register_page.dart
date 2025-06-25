import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/auth_provider.dart';
import '../widgets/register/register_data_loader.dart';
import '../widgets/register/register_form_pages.dart';
import '../widgets/register/register_navigation.dart';
import '../widgets/register/register_progress.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _slideController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().clearError();
    });
  }

  void _initAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: CommonAppBar(title: 'Create Account', showBackButton: true),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          _handleAuthStateChanges(authProvider);

          if (authProvider.isLoading) {
            return const Center(
              child: LoadingWidget(message: 'Creating your account...'),
            );
          }

          return Column(
            children: [
              RegisterProgress(currentPage: _currentPage),
              Expanded(
                child: RegisterDataLoader(
                  child: RegisterFormPages(
                    pageController: _pageController,
                    onPageChanged: (page) =>
                        setState(() => _currentPage = page),
                  ),
                ),
              ),
              RegisterNavigation(
                currentPage: _currentPage,
                pageController: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleAuthStateChanges(AuthProvider authProvider) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authProvider.isOtpRequired) {
        context.go(
          '${RouteConstants.otpVerification}?email=${authProvider.emailController.text}&isLogin=false',
        );
      } else if (authProvider.hasError) {
        ErrorHandler.showError(
          context,
          ServerFailure(message: authProvider.errorMessage ?? ""),
        );
      }
    });
  }
}
