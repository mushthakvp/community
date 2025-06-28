import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/inputs/text_field.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/profile_provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Change Password'),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.changePasswordState == ProfileState.loading) {
            return const Center(
              child: LoadingWidget(message: 'Changing password...'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildPasswordImage(),
                  const SizedBox(height: 32),
                  _buildPasswordFields(provider),
                  const SizedBox(height: 32),
                  _buildChangePasswordButton(provider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPasswordImage() {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: AppConstants.appPrimaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.lock_outline,
          size: 60,
          color: AppConstants.appPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildPasswordFields(ProfileProvider provider) {
    return Column(
      children: [
        _buildPasswordField(
          controller: _currentPasswordController,
          labelText: 'Current Password',
          isObscure: !provider.isCurrentPasswordVisible,
          onToggleVisibility: provider.toggleCurrentPasswordVisibility,
          validator: (value) => Validators.required(value, 'current password'),
        ),
        const SizedBox(height: 16),
        _buildPasswordField(
          controller: _newPasswordController,
          labelText: 'New Password',
          isObscure: !provider.isNewPasswordVisible,
          onToggleVisibility: provider.toggleNewPasswordVisibility,
          validator: Validators.password,
        ),
        const SizedBox(height: 16),
        _buildPasswordField(
          controller: _confirmPasswordController,
          labelText: 'Confirm New Password',
          isObscure: !provider.isConfirmPasswordVisible,
          onToggleVisibility: provider.toggleConfirmPasswordVisibility,
          validator: (value) =>
              Validators.confirmPassword(value, _newPasswordController.text),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool isObscure,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return CommonTextField(
      controller: controller,
      labelText: labelText,
      obscureText: isObscure,
      validator: validator,
      suffixIcon: IconButton(
        onPressed: onToggleVisibility,
        icon: Icon(
          isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: AppConstants.white.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton(ProfileProvider provider) {
    return PrimaryButton(
      text: 'Change Password',
      isLoading: provider.changePasswordState == ProfileState.loading,
      onPressed: _changePassword,
      height: 56,
    );
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<ProfileProvider>();

      provider
          .changePassword(
            oldPassword: _currentPasswordController.text.trim(),
            newPassword: _newPasswordController.text.trim(),
          )
          .then((_) {
            if (provider.changePasswordState == ProfileState.success) {
              context.showSuccessSnackBar('Password changed successfully');
              _clearFields();
              Navigator.of(context).pop();
            } else if (provider.changePasswordState == ProfileState.error) {
              context.showErrorSnackBar(
                provider.changePasswordError ?? 'Failed to change password',
              );
            }
          });
    }
  }

  void _clearFields() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }
}
