import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app_constants.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsets? contentPadding;
  final void Function(String?)? onSaved;

  const CommonTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.contentPadding,
    this.onSaved,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  @override
  Widget build(BuildContext context) {
    return Focus(
      child: TextFormField(
        onSaved: widget.onSaved,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        onTap: widget.onTap,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        textCapitalization: widget.textCapitalization,
        inputFormatters: widget.inputFormatters,
        focusNode: widget.focusNode,
        textAlign: widget.textAlign,
        style: const TextStyle(color: AppConstants.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          filled: true,
          counter: SizedBox.shrink(),
          fillColor: widget.backgroundColor ?? AppConstants.textFieldColor,
          contentPadding:
              widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintStyle: TextStyle(
            color: AppConstants.white.withOpacity(0.6),
            fontSize: 16,
          ),
          labelStyle: TextStyle(
            color: AppConstants.white.withOpacity(0.6),
            fontSize: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? AppConstants.defaultBorderRadius,
            ),
            borderSide: BorderSide(
              color: widget.borderColor ?? AppConstants.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? AppConstants.defaultBorderRadius,
            ),
            borderSide: BorderSide(
              color: widget.borderColor ?? AppConstants.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? AppConstants.defaultBorderRadius,
            ),
            borderSide: BorderSide(color: AppConstants.transparent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? AppConstants.defaultBorderRadius,
            ),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? AppConstants.defaultBorderRadius,
            ),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}
