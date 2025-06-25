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
  bool _isNavigating = false;
  bool _hasRegistrationError = false; // Track registration errors

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
      appBar: const CommonAppBar(title: 'Create Account', showBackButton: true),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          _handleAuthStateChanges(authProvider);

          if (authProvider.isLoading && _isNavigating) {
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
                    onPageChanged: (page) => _handlePageChanged(page),
                  ),
                ),
              ),
              RegisterNavigation(
                currentPage: _currentPage,
                pageController: _pageController,
                onPageChanged: (page) => _handlePageChanged(page),
                onRegisterPressed: () => _handleRegister(authProvider),
                isLoading: authProvider.isLoading && _isNavigating,
              ),
            ],
          );
        },
      ),
    );
  }

  void _handlePageChanged(int page) {
    if (mounted) {
      setState(() {
        _currentPage = page;
        _hasRegistrationError = false; // Reset error flag when changing pages
      });
    }
  }

  void _handleRegister(AuthProvider authProvider) {
    // Don't start registration if there was a previous error
    // and user is still on the same page
    if (_hasRegistrationError && _currentPage == 2) {
      _hasRegistrationError = false; // Reset the flag
    }

    setState(() {
      _isNavigating = true;
    });
    authProvider.register();
  }

  void _handleAuthStateChanges(AuthProvider authProvider) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authProvider.isOtpRequired) {
        setState(() {
          _isNavigating = false;
          _hasRegistrationError = false;
        });
        context.go(
          '${RouteConstants.otpVerification}?email=${authProvider.emailController.text}&isLogin=false',
        );
      } else if (authProvider.hasError) {
        setState(() {
          _isNavigating = false;
          _hasRegistrationError = true; // Mark that there was an error
        });
        ErrorHandler.showError(
          context,
          ServerFailure(message: authProvider.errorMessage ?? ""),
        );
        // Don't navigate to first page automatically
        // User can stay on current page and fix the issue
      }
    });
  }
}
