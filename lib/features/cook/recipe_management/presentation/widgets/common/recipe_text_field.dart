import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_constants.dart';

class RecipeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final Color backgroundColor;
  final Color borderColor;
  final Widget? suffixIcon;

  const RecipeTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.backgroundColor = AppConstants.darkBlack,
    this.borderColor = AppConstants.darkBlack,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
        border: borderColor != backgroundColor
            ? Border.all(color: borderColor)
            : null,
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'HelveticaNeue',
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppConstants.hintTextColor,
            fontFamily: 'HelveticaNeue',
            fontWeight: FontWeight.w300,
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 15,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
