import 'package:flutter/material.dart';

/// Horizontal spacing widget
class HorizontalSpace extends StatelessWidget {
  final double width;

  const HorizontalSpace(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

/// Vertical spacing widget
class VerticalSpace extends StatelessWidget {
  final double height;

  const VerticalSpace(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

/// Common spacing constants
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Vertical spacing helpers
  static const Widget verticalXS = VerticalSpace(xs);
  static const Widget verticalSM = VerticalSpace(sm);
  static const Widget verticalMD = VerticalSpace(md);
  static const Widget verticalLG = VerticalSpace(lg);
  static const Widget verticalXL = VerticalSpace(xl);
  static const Widget verticalXXL = VerticalSpace(xxl);

  // Horizontal spacing helpers
  static const Widget horizontalXS = HorizontalSpace(xs);
  static const Widget horizontalSM = HorizontalSpace(sm);
  static const Widget horizontalMD = HorizontalSpace(md);
  static const Widget horizontalLG = HorizontalSpace(lg);
  static const Widget horizontalXL = HorizontalSpace(xl);
  static const Widget horizontalXXL = HorizontalSpace(xxl);
}
