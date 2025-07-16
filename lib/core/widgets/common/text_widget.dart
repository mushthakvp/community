// lib/core/widgets/common/text_widget.dart
import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';

class CommonTextWidget extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height;
  final TextDecoration? decoration;
  final String? fontFamily;
  final FontStyle? fontStyle;
  final List<Shadow>? shadows;
  final Paint? foreground;
  final Paint? background;

  const CommonTextWidget({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.decoration,
    this.fontFamily,
    this.fontStyle,
    this.shadows,
    this.foreground,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      style: TextStyle(
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: foreground == null ? (color ?? AppConstants.white) : null,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        height: height,
        decoration: decoration ?? TextDecoration.none,
        fontFamily: fontFamily ?? AppConstants.fontFamily,
        fontStyle: fontStyle,
        shadows: shadows,
        foreground: foreground,
        background: background,
      ),
    );
  }
}

// Predefined text styles for consistency
class CommonTextStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppConstants.white,
    fontFamily: AppConstants.fontFamily,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppConstants.white,
    fontFamily: AppConstants.fontFamily,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppConstants.white,
    fontFamily: AppConstants.fontFamily,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppConstants.white,
    fontFamily: AppConstants.fontFamily,
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppConstants.white,
    fontFamily: AppConstants.fontFamily,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppConstants.white,
    fontFamily: AppConstants.fontFamily,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppConstants.white,
    fontFamily: AppConstants.fontFamily,
  );

  // Caption and labels
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppConstants.white,
    fontFamily: AppConstants.fontFamily,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppConstants.white,
    fontFamily: AppConstants.fontFamily,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppConstants.white,
    fontFamily: AppConstants.fontFamily,
  );

  // Error text
  static const TextStyle error = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.red,
    fontFamily: AppConstants.fontFamily,
  );

  // Success text
  static const TextStyle success = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.green,
    fontFamily: AppConstants.fontFamily,
  );
}

// Extension for easy text styling
extension TextStyleExtension on CommonTextWidget {
  CommonTextWidget get heading1 => CommonTextWidget(
    text: text,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: color ?? AppConstants.white,
    align: align,
    maxLines: maxLines,
  );

  CommonTextWidget get heading2 => CommonTextWidget(
    text: text,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: color ?? AppConstants.white,
    align: align,
    maxLines: maxLines,
  );

  CommonTextWidget get heading3 => CommonTextWidget(
    text: text,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: color ?? AppConstants.white,
    align: align,
    maxLines: maxLines,
  );

  CommonTextWidget get bodyLarge => CommonTextWidget(
    text: text,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: color ?? AppConstants.white,
    align: align,
    maxLines: maxLines,
  );

  CommonTextWidget get caption => CommonTextWidget(
    text: text,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color ?? AppConstants.white.withOpacity(0.7),
    align: align,
    maxLines: maxLines,
  );
}
