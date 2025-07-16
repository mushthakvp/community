// lib/core/widgets/common/inkwell_widget.dart
import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';

class CommonInkWell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Color? highlightColor;
  final EdgeInsets? padding;
  final bool enabled;

  const CommonInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.splashColor,
    this.highlightColor,
    this.padding,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget inkWell = InkWell(
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      borderRadius:
          borderRadius ??
          BorderRadius.circular(AppConstants.defaultBorderRadius),
      splashColor: splashColor ?? AppConstants.appPrimaryColor.withOpacity(0.2),
      highlightColor:
          highlightColor ?? AppConstants.appPrimaryColor.withOpacity(0.1),
      child: child,
    );

    if (padding != null) {
      inkWell = Padding(padding: padding!, child: inkWell);
    }

    return inkWell;
  }
}
