import 'package:flutter/material.dart';

import '../constants/vcart_colors.dart';
import '../constants/vcart_constants.dart';

extension VCartContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isTablet => screenWidth >= 768;
  bool get isMobile => screenWidth < 768;

  EdgeInsets get defaultPadding =>
      const EdgeInsets.all(VCartConstants.defaultPadding);
  EdgeInsets get smallPadding =>
      const EdgeInsets.all(VCartConstants.smallPadding);
  EdgeInsets get largePadding =>
      const EdgeInsets.all(VCartConstants.largePadding);

  EdgeInsets get horizontalPadding =>
      const EdgeInsets.symmetric(horizontal: VCartConstants.defaultPadding);
  EdgeInsets get verticalPadding =>
      const EdgeInsets.symmetric(vertical: VCartConstants.defaultPadding);

  void showVCartSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: VCartColors.onPrimary),
        ),
        backgroundColor: isError ? VCartColors.error : VCartColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VCartConstants.defaultRadius),
        ),
        margin: defaultPadding,
      ),
    );
  }
}

extension VCartStringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullAndNotEmpty => !isNullOrEmpty;

  String get orEmpty => this ?? '';
  String get orPlaceholder =>
      isNullOrEmpty ? VCartConstants.placeholderImageUrl : this!;
}

extension VCartNumberExtensions on num {
  String get formatPrice => 'AED ${toStringAsFixed(2)}';
  String get formatPriceWithoutDecimal => 'AED ${toInt()}';
}
