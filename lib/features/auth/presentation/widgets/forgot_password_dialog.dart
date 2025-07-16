// lib/features/auth/presentation/widgets/forgot_password_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/inputs/text_field.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppConstants.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildEmailField(),
              const SizedBox(height: 24),
              _buildActionButtons(),
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
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppConstants.appPrimaryColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_reset,
            color: AppConstants.appPrimaryColor,
            size: 30,
          ),
        ),
        const SizedBox(height: 16),
        const CommonTextWidget(
          text: 'Forgot Password?',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
          align: TextAlign.center,
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text:
              'Enter your email address and we\'ll send you a link to reset your password.',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.7),
          align: TextAlign.center,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return CommonTextField(
      controller: _emailController,
      hintText: 'Enter your email address',
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email_outlined, color: AppConstants.white),
      validator: Validators.email,
      enabled: !_isLoading,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            text: 'Cancel',
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            backgroundColor: Colors.transparent,
            borderColor: AppConstants.white.withOpacity(0.3),
            textColor: AppConstants.white,
            height: 48,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PrimaryButton(
            text: 'Send Reset Link',
            onPressed: _isLoading ? null : _handleForgotPassword,
            backgroundColor: AppConstants.appPrimaryColor,
            textColor: AppConstants.black,
            height: 48,
            isLoading: _isLoading,
          ),
        ),
      ],
    );
  }

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.forgotPassword(_emailController.text.trim());

      if (mounted) {
        // Close the dialog first
        Navigator.of(context).pop();

        // Show success message with better styling
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Reset Link Sent!',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Check your email: ${_emailController.text.trim()}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );

        // Optional: Show a dialog with more detailed instructions
        _showEmailSentDialog(_emailController.text.trim());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Failed to send reset link: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showEmailSentDialog(String email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.email_outlined,
                color: Colors.green,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: CommonTextWidget(
                text: 'Check Your Email',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextWidget(
              text: 'We\'ve sent a password reset link to:',
              fontSize: 14,
              color: AppConstants.white.withOpacity(0.8),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppConstants.appPrimaryColor.withOpacity(0.3),
                ),
              ),
              child: CommonTextWidget(
                text: email,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            CommonTextWidget(
              text:
                  'Please check your email and follow the instructions to reset your password.',
              fontSize: 14,
              color: AppConstants.white.withOpacity(0.8),
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: 'Don\'t see the email? Check your spam folder.',
              fontSize: 12,
              color: AppConstants.white.withOpacity(0.6),
              fontStyle: FontStyle.italic,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const CommonTextWidget(
              text: 'Got it',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.appPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
