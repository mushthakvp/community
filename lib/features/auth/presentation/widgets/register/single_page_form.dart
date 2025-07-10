import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../../providers/auth_provider.dart';
import '../gender_selection.dart';
import '../password_field.dart';
import '../phone_number_field.dart';
import '../profile_image_picker.dart';
import '../terms_checkbox.dart';
import 'fields/date_of_birth_field.dart';
import 'fields/profession_field.dart';
import 'fields/smart_location_fields.dart';

class SinglePageForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onRegisterPressed;
  final bool isLoading;

  const SinglePageForm({
    super.key,
    required this.formKey,
    required this.onRegisterPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),

            // Profile Image
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return ProfileImagePicker(
                  onImageSelected: (image) {
                    authProvider.setProfileImage(image);
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // Basic Information Section
            _buildSectionHeader('Basic Information'),
            const SizedBox(height: 16),
            _buildBasicInfoFields(),

            const SizedBox(height: 24),

            // Personal Details Section
            _buildSectionHeader('Personal Details'),
            const SizedBox(height: 16),
            _buildPersonalInfoFields(),

            const SizedBox(height: 24),

            // Account Security Section
            _buildSectionHeader('Account Security'),
            const SizedBox(height: 16),
            _buildSecurityFields(),

            const SizedBox(height: 32),

            // Terms and Register Button
            TermsCheckbox(
              onTermsPressed: () =>
                  context.push(RouteConstants.termsConditions),
              onPrivacyPressed: () => _openUrl('https://vivera.com/privacy'),
            ),

            const SizedBox(height: 24),

            _buildRegisterButton(),

            const SizedBox(height: 16),

            _buildLoginPrompt(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const CommonTextWidget(
          text: 'Join Livera Community',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppConstants.white,
          align: TextAlign.center,
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: 'Create your account in just a few steps',
          fontSize: 16,
          color: AppConstants.white.withOpacity(0.7),
          align: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return CommonTextWidget(
      text: title,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppConstants.appPrimaryColor,
    );
  }

  Widget _buildBasicInfoFields() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          children: [
            CommonTextField(
              controller: authProvider.nameController,
              hintText: 'Full Name *',
              prefixIcon: const Icon(
                Icons.person_outline,
                color: AppConstants.white,
              ),
              validator: (value) => Validators.required(value, 'name'),
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: authProvider.emailController,
              hintText: 'Email Address *',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AppConstants.white,
              ),
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            PhoneNumberField(validator: Validators.phone),
          ],
        );
      },
    );
  }

  Widget _buildPersonalInfoFields() {
    return Column(
      children: [
        const GenderSelection(),
        const SizedBox(height: 20),
        const DateOfBirthField(),
        const SizedBox(height: 16),
        const ProfessionField(),
        const SizedBox(height: 16),

        // Smart Location Fields - Only asks for state/district since country is from phone
        const SmartLocationFields(),
      ],
    );
  }

  Widget _buildSecurityFields() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          children: [
            PasswordField(
              controller: authProvider.passwordController,
              hintText: 'Create Password *',
              isVisible: authProvider.isPasswordVisible,
              onToggleVisibility: authProvider.togglePasswordVisibility,
              validator: Validators.password,
            ),
            const SizedBox(height: 16),
            PasswordField(
              controller: authProvider.confirmPasswordController,
              hintText: 'Confirm Password *',
              isVisible: authProvider.isConfirmPasswordVisible,
              onToggleVisibility: authProvider.toggleConfirmPasswordVisibility,
              validator: (value) => Validators.confirmPassword(
                value,
                authProvider.passwordController.text,
              ),
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: authProvider.referralCodeController,
              hintText: 'Referral Code (Optional)',
              prefixIcon: const Icon(
                Icons.card_giftcard_outlined,
                color: AppConstants.white,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRegisterButton() {
    return PrimaryButton(
      text: 'Create Account',
      onPressed: isLoading ? null : onRegisterPressed,
      isLoading: isLoading,
      height: 56,
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CommonTextWidget(
          text: "Already have an account? ",
          fontSize: 14,
          color: AppConstants.white.withOpacity(0.7),
        ),
        TextButton(
          onPressed: () => context.go(RouteConstants.login),
          child: const CommonTextWidget(
            text: 'Sign In',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppConstants.appPrimaryColor,
          ),
        ),
      ],
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
