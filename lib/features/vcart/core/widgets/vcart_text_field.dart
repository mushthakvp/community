import 'package:flutter/material.dart';

import '../constants/vcart_colors.dart';
import '../constants/vcart_constants.dart';

class VCartTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final FocusNode? focusNode;

  const VCartTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onTap,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onTap: onTap,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      focusNode: focusNode,
      style: const TextStyle(color: VCartColors.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: const TextStyle(
          color: VCartColors.textSecondary,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: VCartColors.textSecondary,
          fontSize: 14,
        ),
        filled: true,
        fillColor: VCartColors.surface,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VCartConstants.defaultRadius),
          borderSide: const BorderSide(color: VCartColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VCartConstants.defaultRadius),
          borderSide: const BorderSide(color: VCartColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VCartConstants.defaultRadius),
          borderSide: const BorderSide(color: VCartColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VCartConstants.defaultRadius),
          borderSide: const BorderSide(color: VCartColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VCartConstants.defaultRadius),
          borderSide: const BorderSide(color: VCartColors.error),
        ),
        counterStyle: const TextStyle(color: VCartColors.textSecondary),
        errorStyle: const TextStyle(color: VCartColors.error),
      ),
    );
  }
}
