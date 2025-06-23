// lib/core/widgets/common_button.dart

import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import 'common_text_widget.dart';

class CommonButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? bgColor;
  final Color? borderColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? prefix;
  final Widget? suffix;
  final bool isLoading;
  final bool isEnabled;
  final double? borderWidth;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final double? elevation;

  const CommonButton({
    super.key,
    required this.text,
    this.onTap,
    this.bgColor,
    this.borderColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.prefix,
    this.suffix,
    this.isLoading = false,
    this.isEnabled = true,
    this.borderWidth,
    this.boxShadow,
    this.gradient,
    this.elevation,
  });

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: widget.margin,
            child: Material(
              elevation: widget.elevation ?? 0,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleTap,
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
                child: Container(
                  height: widget.height ?? 50,
                  width: widget.width,
                  padding:
                      widget.padding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(),
                    gradient: widget.gradient,
                    border: widget.borderColor != null
                        ? Border.all(
                            color: widget.borderColor!,
                            width: widget.borderWidth ?? 1,
                          )
                        : null,
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(8),
                    boxShadow: widget.boxShadow,
                  ),
                  child: _buildContent(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.textColor ?? AppConstants.white,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.prefix != null) ...[
          widget.prefix!,
          const SizedBox(width: 8),
        ],
        Flexible(
          child: CommonTextWidget(
            text: widget.text,
            fontSize: widget.fontSize ?? 16,
            fontWeight: widget.fontWeight ?? FontWeight.w600,
            color: widget.textColor ?? AppConstants.white,
            align: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (widget.suffix != null) ...[
          const SizedBox(width: 8),
          widget.suffix!,
        ],
      ],
    );
  }

  Color _getBackgroundColor() {
    if (!widget.isEnabled) {
      return (widget.bgColor ?? AppConstants.appPrimaryColor).withOpacity(0.5);
    }
    return widget.bgColor ?? AppConstants.appPrimaryColor;
  }

  void _handleTap() {
    if (widget.isEnabled && !widget.isLoading && widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.isEnabled && !widget.isLoading) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.isEnabled && !widget.isLoading) {
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.isEnabled && !widget.isLoading) {
      _animationController.reverse();
    }
  }
}

/// Predefined button styles for consistency
class CommonButtonStyles {
  // Primary button
  static CommonButton primary({
    required String text,
    required VoidCallback? onTap,
    bool isLoading = false,
    bool isEnabled = true,
    Widget? prefix,
    Widget? suffix,
  }) {
    return CommonButton(
      text: text,
      onTap: onTap,
      bgColor: AppConstants.appPrimaryColor,
      textColor: AppConstants.black,
      borderRadius: BorderRadius.circular(12),
      height: 50,
      fontWeight: FontWeight.w600,
      isLoading: isLoading,
      isEnabled: isEnabled,
      prefix: prefix,
      suffix: suffix,
    );
  }

  // Secondary button
  static CommonButton secondary({
    required String text,
    required VoidCallback? onTap,
    bool isLoading = false,
    bool isEnabled = true,
    Widget? prefix,
    Widget? suffix,
  }) {
    return CommonButton(
      text: text,
      onTap: onTap,
      bgColor: Colors.transparent,
      borderColor: AppConstants.appPrimaryColor,
      textColor: AppConstants.appPrimaryColor,
      borderRadius: BorderRadius.circular(12),
      height: 50,
      fontWeight: FontWeight.w600,
      isLoading: isLoading,
      isEnabled: isEnabled,
      prefix: prefix,
      suffix: suffix,
    );
  }

  // Danger button
  static CommonButton danger({
    required String text,
    required VoidCallback? onTap,
    bool isLoading = false,
    bool isEnabled = true,
    Widget? prefix,
    Widget? suffix,
  }) {
    return CommonButton(
      text: text,
      onTap: onTap,
      bgColor: Colors.red,
      textColor: AppConstants.white,
      borderRadius: BorderRadius.circular(12),
      height: 50,
      fontWeight: FontWeight.w600,
      isLoading: isLoading,
      isEnabled: isEnabled,
      prefix: prefix,
      suffix: suffix,
    );
  }

  // Small button
  static CommonButton small({
    required String text,
    required VoidCallback? onTap,
    Color? bgColor,
    Color? textColor,
    bool isLoading = false,
    bool isEnabled = true,
  }) {
    return CommonButton(
      text: text,
      onTap: onTap,
      bgColor: bgColor ?? AppConstants.appPrimaryColor,
      textColor: textColor ?? AppConstants.black,
      borderRadius: BorderRadius.circular(8),
      height: 36,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      isLoading: isLoading,
      isEnabled: isEnabled,
    );
  }

  // Icon button
  static CommonButton icon({
    required String text,
    required IconData icon,
    required VoidCallback? onTap,
    Color? bgColor,
    Color? textColor,
    Color? iconColor,
    bool isLoading = false,
    bool isEnabled = true,
  }) {
    return CommonButton(
      text: text,
      onTap: onTap,
      bgColor: bgColor ?? AppConstants.appPrimaryColor,
      textColor: textColor ?? AppConstants.black,
      borderRadius: BorderRadius.circular(12),
      height: 50,
      fontWeight: FontWeight.w600,
      isLoading: isLoading,
      isEnabled: isEnabled,
      prefix: Icon(
        icon,
        color: iconColor ?? textColor ?? AppConstants.black,
        size: 20,
      ),
    );
  }
}
