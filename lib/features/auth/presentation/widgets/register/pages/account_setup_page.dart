import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/constants/route_constants.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../../../../core/widgets/inputs/text_field.dart';
import '../../../providers/auth_provider.dart';
import '../../password_field.dart';
import '../../terms_checkbox.dart';

class AccountSetupPage extends StatelessWidget {
  const AccountSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CommonTextWidget(
                text: 'Secure Your Account',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.white,
              ),
              const SizedBox(height: 8),
              CommonTextWidget(
                text: 'Create a strong password',
                fontSize: 16,
                color: AppConstants.white.withOpacity(0.7),
              ),
              const SizedBox(height: 32),
              PasswordField(
                controller: authProvider.passwordController,
                hintText: 'Create Password *',
                isVisible: authProvider.isPasswordVisible,
                onToggleVisibility: authProvider.togglePasswordVisibility,
                validator: Validators.password,
              ),
              const SizedBox(height: 20),
              PasswordField(
                controller: authProvider.confirmPasswordController,
                hintText: 'Confirm Password *',
                isVisible: authProvider.isConfirmPasswordVisible,
                onToggleVisibility:
                    authProvider.toggleConfirmPasswordVisibility,
                validator: (value) => Validators.confirmPassword(
                  value,
                  authProvider.passwordController.text,
                ),
              ),
              const SizedBox(height: 20),
              CommonTextField(
                controller: authProvider.referralCodeController,
                hintText: 'Referral Code (Optional)',
                prefixIcon: const Icon(
                  Icons.card_giftcard_outlined,
                  color: AppConstants.white,
                ),
              ),
              const SizedBox(height: 32),
              TermsCheckbox(
                onTermsPressed: () =>
                    context.push(RouteConstants.termsConditions),
                onPrivacyPressed: () => _openUrl('https://vivera.com/privacy'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch $url: $e');
    }
  }
}
