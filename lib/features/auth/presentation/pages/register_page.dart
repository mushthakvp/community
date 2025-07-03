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
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  bool _isNavigating = false;
  bool _isPageControllerReady = false;
  bool _hasHandledError = false;

  late AnimationController _slideController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _initAnimations();

    // Ensure we start at page 0
    _currentPage = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isPageControllerReady = true;
        });
        context.read<AuthProvider>().clearError();

        // Force page controller to be at page 0
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
        }
      }
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
                    onPageChanged: (page) {
                      debugPrint('Page changed to: $page');
                      _handlePageChanged(page);
                    },
                  ),
                ),
              ),
              RegisterNavigation(
                currentPage: _currentPage,
                pageController: _pageController,
                onPageChanged: (page) {
                  debugPrint('Navigation page changed to: $page');
                  _handlePageChanged(page);
                },
                onRegisterPressed: () => _handleRegister(authProvider),
                onForceReset: () => _forceResetToFirstPage(),
                isLoading: authProvider.isLoading && _isNavigating,
              ),
            ],
          );
        },
      ),
    );
  }

  void _handlePageChanged(int page) {
    debugPrint(
      '_handlePageChanged called with page: $page, current: $_currentPage',
    );
    if (mounted) {
      setState(() {
        _currentPage = page;
        _hasHandledError = false;
      });
      debugPrint('Current page updated to: $_currentPage');
    }
  }

  void _handleRegister(AuthProvider authProvider) {
    setState(() {
      _isNavigating = true;
      _hasHandledError = false;
    });
    authProvider.register();
  }

  void _handleAuthStateChanges(AuthProvider authProvider) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (authProvider.isOtpRequired) {
        setState(() {
          _isNavigating = false;
          _hasHandledError = false;
        });
        context.go(
          '${RouteConstants.otpVerification}?email=${authProvider.emailController.text}&isLogin=false',
        );
      } else if (authProvider.hasError && !_hasHandledError) {
        debugPrint('Error occurred: ${authProvider.errorMessage}');
        setState(() {
          _isNavigating = false;
          _hasHandledError = true;
        });

        // Show error message
        ErrorHandler.showError(
          context,
          ServerFailure(
            message: authProvider.errorMessage ?? "Registration failed",
          ),
        );

        // Reset to first page - do this immediately and forcefully
        _resetToFirstPage();
      }
    });
  }

  void _forceResetToFirstPage() {
    debugPrint('_forceResetToFirstPage called');

    if (mounted) {
      setState(() {
        _currentPage = 0;
        _isNavigating = false;
        _hasHandledError = false;
      });

      // Force page controller to page 0
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0); // Use jumpToPage for immediate reset
      }

      // Clear any error state
      context.read<AuthProvider>().clearError();
    }
  }

  void _resetToFirstPage() {
    debugPrint('_resetToFirstPage called - current page: $_currentPage');

    if (mounted) {
      // Force reset the state immediately
      setState(() {
        _currentPage = 0;
        _isNavigating = false;
      });

      // Force the page controller to page 0
      if (_isPageControllerReady && _pageController.hasClients) {
        try {
          _pageController
              .animateToPage(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              )
              .then((_) {
                if (mounted) {
                  // Double-check the state is correct
                  setState(() {
                    _currentPage = 0;
                  });

                  // Clear error after animation with longer delay
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted) {
                      context.read<AuthProvider>().clearError();
                    }
                  });
                }
              });
        } catch (e) {
          debugPrint('Failed to navigate to first page: $e');
          if (mounted) {
            // Fallback - just ensure state is correct
            setState(() {
              _currentPage = 0;
              _isNavigating = false;
            });
            context.read<AuthProvider>().clearError();
          }
        }
      } else {
        // If page controller not ready, just reset state
        setState(() {
          _currentPage = 0;
          _isNavigating = false;
        });
        context.read<AuthProvider>().clearError();
      }
    }
  }
}
