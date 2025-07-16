import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';

class RegisterNavigation extends StatefulWidget {
  final int currentPage;
  final PageController pageController;
  final Function(int) onPageChanged;
  final VoidCallback? onRegisterPressed;
  final VoidCallback? onForceReset;
  final bool isLoading;

  const RegisterNavigation({
    super.key,
    required this.currentPage,
    required this.pageController,
    required this.onPageChanged,
    this.onRegisterPressed,
    this.onForceReset,
    this.isLoading = false,
  });

  @override
  State<RegisterNavigation> createState() => _RegisterNavigationState();
}

class _RegisterNavigationState extends State<RegisterNavigation> {
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppConstants.black,
        border: Border(
          top: BorderSide(color: AppConstants.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                10.h,
                Row(
                  children: [
                    if (widget.currentPage > 0) ...[
                      Expanded(flex: 2, child: _buildBackButton(authProvider)),
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      flex: 3,
                      child: _buildNextButton(context, authProvider),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackButton(AuthProvider authProvider) {
    final isDisabled =
        widget.isLoading || authProvider.isLoading || _isNavigating;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDisabled
              ? AppConstants.appPrimaryColor.withOpacity(0.3)
              : AppConstants.appPrimaryColor,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isDisabled ? null : _handleBack,
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: isDisabled
                      ? AppConstants.appPrimaryColor.withOpacity(0.5)
                      : AppConstants.appPrimaryColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDisabled
                        ? AppConstants.appPrimaryColor.withOpacity(0.5)
                        : AppConstants.appPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, AuthProvider authProvider) {
    final isLastPage =
        widget.currentPage == 2; // Page 2 is the last page (0, 1, 2)
    final isDisabled =
        widget.isLoading || authProvider.isLoading || _isNavigating;

    debugPrint(
      '_buildNextButton - currentPage: ${widget.currentPage}, isLastPage: $isLastPage',
    );

    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: isDisabled
            ? LinearGradient(
                colors: [
                  AppConstants.appPrimaryColor.withOpacity(0.3),
                  const Color(0xFF00D4AA).withOpacity(0.3),
                ],
              )
            : const LinearGradient(
                colors: [AppConstants.appPrimaryColor, Color(0xFF00D4AA)],
              ),
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: AppConstants.appPrimaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isDisabled
              ? null
              : () => isLastPage
                    ? _handleRegister(context, authProvider)
                    : _handleNext(context, authProvider),
          child: Container(
            alignment: Alignment.center,
            child: (widget.isLoading || authProvider.isLoading) && isLastPage
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppConstants.black,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLastPage ? 'Create Account' : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.black,
                        ),
                      ),
                      if (!isLastPage) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: AppConstants.black,
                          size: 16,
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleNext(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    if (_isNavigating) return;

    // Validate current page
    if (!_validateCurrentPage(context, authProvider)) return;

    setState(() {
      _isNavigating = true;
    });

    try {
      if (widget.pageController.hasClients) {
        await widget.pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } catch (e) {
      debugPrint('Navigation error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    }
  }

  Future<void> _handleBack() async {
    if (_isNavigating) return;

    setState(() {
      _isNavigating = true;
    });

    try {
      if (widget.pageController.hasClients) {
        await widget.pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } catch (e) {
      debugPrint('Navigation error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    }
  }

  void _handleRegister(BuildContext context, AuthProvider authProvider) {
    if (_validateCurrentPage(context, authProvider)) {
      widget.onRegisterPressed?.call();
    }
  }

  bool _validateCurrentPage(BuildContext context, AuthProvider authProvider) {
    // Add validation logic here based on current page
    switch (widget.currentPage) {
      case 0:
        return _validateBasicInfo(context, authProvider);
      case 1:
        return _validatePersonalInfo(context, authProvider);
      case 2:
        return _validateAccountSetup(context, authProvider);
      default:
        return true;
    }
  }

  bool _validateBasicInfo(BuildContext context, AuthProvider authProvider) {
    if (authProvider.nameController.text.trim().isEmpty) {
      _showError(context, 'Please enter your full name');
      return false;
    }
    if (authProvider.emailController.text.trim().isEmpty) {
      _showError(context, 'Please enter your email address');
      return false;
    }
    if (authProvider.phoneController.text.trim().isEmpty) {
      _showError(context, 'Please enter your phone number');
      return false;
    }
    return true;
  }

  bool _validatePersonalInfo(BuildContext context, AuthProvider authProvider) {
    if (authProvider.selectedGender.isEmpty) {
      _showError(context, 'Please select your gender');
      return false;
    }
    if (authProvider.selectedDateOfBirth == null) {
      _showError(context, 'Please select your date of birth');
      return false;
    }
    if (authProvider.selectedProfession.isEmpty) {
      _showError(context, 'Please select your profession');
      return false;
    }
    if (authProvider.selectedCountry.isEmpty) {
      _showError(context, 'Please select your country');
      return false;
    }
    if (authProvider.selectedState.isEmpty) {
      _showError(context, 'Please select your state');
      return false;
    }
    return true;
  }

  bool _validateAccountSetup(BuildContext context, AuthProvider authProvider) {
    if (authProvider.passwordController.text.trim().length < 8) {
      _showError(context, 'Password must be at least 8 characters long');
      return false;
    }
    if (authProvider.passwordController.text.trim() !=
        authProvider.confirmPasswordController.text.trim()) {
      _showError(context, 'Passwords do not match');
      return false;
    }
    if (!authProvider.agreeToTerms) {
      _showError(context, 'Please agree to the terms and conditions');
      return false;
    }
    return true;
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
