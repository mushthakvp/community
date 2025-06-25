// lib/features/auth/presentation/widgets/register/register_validator.dart - Fixed
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../providers/auth_provider.dart';

class RegisterValidator {
  static bool validateCurrentPage(
    BuildContext context,
    int currentPage,
    AuthProvider authProvider,
  ) {
    switch (currentPage) {
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

  static bool _validateBasicInfo(
    BuildContext context,
    AuthProvider authProvider,
  ) {
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

  static bool _validatePersonalInfo(
    BuildContext context,
    AuthProvider authProvider,
  ) {
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

  static bool _validateAccountSetup(
    BuildContext context,
    AuthProvider authProvider,
  ) {
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

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CommonTextWidget(
          text: message,
          fontSize: 14,
          color: AppConstants.white,
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
