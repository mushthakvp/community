// lib/core/widgets/common/container_widget.dart
import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';

class CommonContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final AlignmentGeometry? alignment;

  const CommonContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.gradient,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
            borderRadius ??
            BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: border,
        boxShadow: boxShadow,
        gradient: gradient,
      ),
      child: child,
    );
  }
}
