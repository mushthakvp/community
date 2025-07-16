import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';

class CommonIconWidget extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;

  const CommonIconWidget({
    super.key,
    required this.icon,
    this.size,
    this.color,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Icon(
      icon,
      size: size ?? 24,
      color: color ?? AppConstants.white,
    );

    if (backgroundColor != null || padding != null) {
      iconWidget = Container(
        padding: padding ?? const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          border: border,
        ),
        child: iconWidget,
      );
    }

    if (onTap != null) {
      iconWidget = InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: iconWidget,
      );
    }

    return iconWidget;
  }
}
