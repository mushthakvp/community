import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import 'text_widget.dart';

class CommonBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CommonBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppConstants.appPrimaryColor,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: CommonTextWidget(
        text: text,
        color: textColor ?? AppConstants.black,
        fontSize: fontSize ?? 12,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
    );
  }
}
