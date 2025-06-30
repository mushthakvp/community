import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';

class CommonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final double? elevation;
  final VoidCallback? onTap;
  final Color? borderColor;

  const CommonCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.elevation,
    this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFF1A1A1A),
        borderRadius:
            borderRadius ??
            BorderRadius.circular(AppConstants.defaultBorderRadius),
        border:
            border ??
            Border.all(
              color: borderColor ?? AppConstants.white.withOpacity(0.1),
              width: 1,
            ),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: AppConstants.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
        child: child,
      ),
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius:
            borderRadius ??
            BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: card,
      );
    }

    return card;
  }
}
