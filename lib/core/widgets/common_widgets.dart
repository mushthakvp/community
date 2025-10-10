import 'package:flutter/material.dart';

import '../constants/colors.dart';

// Common scaffold widget
class HomeScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const HomeScaffold({super.key, required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: child,
        ),
      ),
    );
  }
}

// Common app bar widget
class VcookCommonAppBar extends StatelessWidget {
  final String title;
  final bool isArrowEnabled;
  final VoidCallback? onBackPressed;

  const VcookCommonAppBar({
    super.key,
    required this.title,
    this.isArrowEnabled = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isArrowEnabled)
          GestureDetector(
            onTap: onBackPressed ?? () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColor.white,
              size: 20,
            ),
          ),
        if (isArrowEnabled) const SizedBox(width: 15),
        Expanded(
          child: text(
            text: title,
            size: 18,
            fontWeight: FontWeight.w600,
            color: AppColor.white,
          ),
        ),
      ],
    );
  }
}

// Common text widget
Widget text({
  required String text,
  double? size,
  FontWeight? fontWeight,
  Color? color,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: size ?? 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? AppColor.white,
      fontFamily: 'HelveticaNeue',
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );
}

// Common button widget
Widget button({
  required String name,
  required VoidCallback? onTap,
  Color? color,
  Color? textColor,
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
  Color? borderColor,
  double? borderRadius,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: height ?? 50,
      decoration: BoxDecoration(
        color: color ?? AppColor.appPrimary,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Center(
        child: text(
          text: name,
          color: textColor ?? AppColor.black,
          size: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w600,
        ),
      ),
    ),
  );
}

// Common text form field widget
Widget buildCommonTextFormField({
  required BuildContext context,
  required TextEditingController controller,
  String? hintText,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
  VoidCallback? onTap,
  Color? bgColor,
  Color? borderColor,
  Widget? suffixIcon,
  bool readOnly = false,
  Function(String)? onChanged,
}) {
  return Container(
    decoration: BoxDecoration(
      color: bgColor ?? AppColor.darkBlack,
      borderRadius: BorderRadius.circular(8),
      border: borderColor != null ? Border.all(color: borderColor) : null,
    ),
    child: TextFormField(
      controller: controller,
      onTap: onTap,
      onChanged: onChanged,
      readOnly: readOnly,
      keyboardType: keyboardType ?? TextInputType.text,
      textInputAction: textInputAction ?? TextInputAction.done,
      style: const TextStyle(
        color: AppColor.white,
        fontFamily: 'HelveticaNeue',
        fontWeight: FontWeight.w300,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColor.hintTextColor,
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

// Common image widget
Widget image({
  required String url,
  double? height,
  double? width,
  double? radius,
  BoxFit? fit,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius ?? 0),
    child: Image.network(
      url,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: AppColor.darkBlack,
            borderRadius: BorderRadius.circular(radius ?? 0),
          ),
          child: const Icon(Icons.image, color: AppColor.white),
        );
      },
    ),
  );
}
