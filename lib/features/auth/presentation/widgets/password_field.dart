import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/inputs/text_field.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isVisible;
  final VoidCallback onToggleVisibility;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isVisible,
    required this.onToggleVisibility,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      controller: controller,
      hintText: hintText,
      obscureText: !isVisible,
      prefixIcon: const Icon(Icons.lock_outline, color: AppConstants.white),
      suffixIcon: IconButton(
        onPressed: onToggleVisibility,
        icon: Icon(
          isVisible ? Icons.visibility_off : Icons.visibility,
          color: AppConstants.white.withOpacity(0.7),
        ),
      ),
      validator: validator,
    );
  }
}
