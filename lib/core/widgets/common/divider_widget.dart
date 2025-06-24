import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';

class CommonDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;

  const CommonDivider({
    super.key,
    this.height,
    this.thickness,
    this.color,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height ?? 1,
      thickness: thickness ?? 1,
      color: color ?? AppConstants.white.withOpacity(0.2),
      indent: indent,
      endIndent: endIndent,
    );
  }
}

class CommonVerticalDivider extends StatelessWidget {
  final double? width;
  final double? thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;

  const CommonVerticalDivider({
    super.key,
    this.width,
    this.thickness,
    this.color,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      width: width ?? 1,
      thickness: thickness ?? 1,
      color: color ?? AppConstants.white.withOpacity(0.2),
      indent: indent,
      endIndent: endIndent,
    );
  }
}
