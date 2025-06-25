import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../providers/auth_provider.dart';
import 'register_validator.dart';

class RegisterNavigation extends StatelessWidget {
  final int currentPage;
  final PageController pageController;
  final Function(int) onPageChanged;
  final VoidCallback? onRegisterPressed;
  final bool isLoading; // Add explicit loading parameter

  const RegisterNavigation({
    super.key,
    required this.currentPage,
    required this.pageController,
    required this.onPageChanged,
    this.onRegisterPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppConstants.black,
        border: Border(
          top: BorderSide(color: AppConstants.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Row(
              children: [
                if (currentPage > 0) ...[
                  Expanded(flex: 2, child: _buildBackButton(authProvider)),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  flex: 3,
                  child: _buildNextButton(context, authProvider),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackButton(AuthProvider authProvider) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.appPrimaryColor, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isLoading
              ? null
              : _previousPage, // Disable when explicitly loading
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: isLoading
                      ? AppConstants.appPrimaryColor.withOpacity(0.5)
                      : AppConstants.appPrimaryColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                CommonTextWidget(
                  text: 'Back',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isLoading
                      ? AppConstants.appPrimaryColor.withOpacity(0.5)
                      : AppConstants.appPrimaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, AuthProvider authProvider) {
    final isLastPage = currentPage == 2;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [AppConstants.appPrimaryColor, Color(0xFF00D4AA)],
        ),
        boxShadow: [
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
          onTap: isLoading
              ? null
              : () => isLastPage
                    ? _handleRegister(context, authProvider)
                    : _nextPage(context, authProvider),
          child: Container(
            alignment: Alignment.center,
            child: isLoading && isLastPage
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
                      CommonTextWidget(
                        text: isLastPage ? 'Create Account' : 'Next',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.black,
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

  void _nextPage(BuildContext context, AuthProvider authProvider) {
    if (RegisterValidator.validateCurrentPage(
      context,
      currentPage,
      authProvider,
    )) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleRegister(BuildContext context, AuthProvider authProvider) {
    if (RegisterValidator.validateCurrentPage(
      context,
      currentPage,
      authProvider,
    )) {
      onRegisterPressed?.call();
    }
  }
}
