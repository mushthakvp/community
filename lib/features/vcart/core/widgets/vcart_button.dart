import 'package:flutter/material.dart';

import '../constants/vcart_colors.dart';
import '../constants/vcart_constants.dart';

enum VCartButtonType { primary, secondary, tertiary, outline }

class VCartButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final VCartButtonType type;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final double? width;
  final double? height;

  const VCartButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = VCartButtonType.primary,
    this.isLoading = false,
    this.isExpanded = false,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final textStyle = _getTextStyle();

    Widget child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(VCartColors.onPrimary),
            ),
          )
        : Row(
            mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: textStyle.color),
                const SizedBox(width: 8),
              ],
              Text(text, style: textStyle),
            ],
          );

    if (isExpanded) {
      child = SizedBox(width: double.infinity, child: child);
    }

    return SizedBox(
      width: width,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: child,
      ),
    );
  }

  ButtonStyle _getButtonStyle() {
    switch (type) {
      case VCartButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: VCartColors.primary,
          foregroundColor: VCartColors.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VCartConstants.defaultRadius),
          ),
        );
      case VCartButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: VCartColors.surface,
          foregroundColor: VCartColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VCartConstants.defaultRadius),
          ),
        );
      case VCartButtonType.tertiary:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: VCartColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VCartConstants.defaultRadius),
          ),
        );
      case VCartButtonType.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: VCartColors.primary,
          elevation: 0,
          side: const BorderSide(color: VCartColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VCartConstants.defaultRadius),
          ),
        );
    }
  }

  TextStyle _getTextStyle() {
    const baseStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

    switch (type) {
      case VCartButtonType.primary:
        return baseStyle.copyWith(color: VCartColors.onPrimary);
      case VCartButtonType.secondary:
        return baseStyle.copyWith(color: VCartColors.textPrimary);
      case VCartButtonType.tertiary:
      case VCartButtonType.outline:
        return baseStyle.copyWith(color: VCartColors.primary);
    }
  }
}
