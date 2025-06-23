import 'package:flutter/material.dart';

import 'responsive.dart';

/// Horizontal spacing widget
class SizeBoxH extends StatelessWidget {
  final double height;

  const SizeBoxH(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: Responsive.height * height / 100);
  }
}

/// Vertical spacing widget
class SizeBoxV extends StatelessWidget {
  final double width;

  const SizeBoxV(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: Responsive.width * width / 100);
  }
}

/// Fixed size horizontal spacing
class SizeBoxHFixed extends StatelessWidget {
  final double height;

  const SizeBoxHFixed(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

/// Fixed size vertical spacing
class SizeBoxVFixed extends StatelessWidget {
  final double width;

  const SizeBoxVFixed(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
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

  // Responsive spacing helpers
  static Widget get verticalXS => const SizedBox(height: xs);
  static Widget get verticalSM => const SizedBox(height: sm);
  static Widget get verticalMD => const SizedBox(height: md);
  static Widget get verticalLG => const SizedBox(height: lg);
  static Widget get verticalXL => const SizedBox(height: xl);
  static Widget get verticalXXL => const SizedBox(height: xxl);

  static Widget get horizontalXS => const SizedBox(width: xs);
  static Widget get horizontalSM => const SizedBox(width: sm);
  static Widget get horizontalMD => const SizedBox(width: md);
  static Widget get horizontalLG => const SizedBox(width: lg);
  static Widget get horizontalXL => const SizedBox(width: xl);
  static Widget get horizontalXXL => const SizedBox(width: xxl);
}
