import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../common/text_widget.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool isLoading;
  final bool isEnabled;
  final Widget? prefix;
  final Widget? suffix;
  final double? borderRadius;
  final double? width;
  final double? height;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.padding,
    this.fontSize,
    this.fontWeight,
    this.isLoading = false,
    this.isEnabled = true,
    this.prefix,
    this.suffix,
    this.borderRadius,
    this.width,
    this.height,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.fastAnimationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
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
          child: _buildButton(),
        );
      },
    );
  }

  Widget _buildButton() {
    final isDisabled = !widget.isEnabled || widget.isLoading;

    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: isDisabled ? null : widget.onPressed,
      child: Container(
        width: widget.width,
        height: widget.height ?? 50,
        padding:
            widget.padding ??
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? AppConstants.appPrimaryColor,
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? AppConstants.defaultBorderRadius,
          ),
          border: widget.borderColor != null
              ? Border.all(color: widget.borderColor!)
              : null,
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppConstants.black),
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
            color: widget.textColor ?? AppConstants.black,
            fontSize: widget.fontSize ?? 16,
            fontWeight: widget.fontWeight ?? FontWeight.w600,
            maxLines: 1,
          ),
        ),
        if (widget.suffix != null) ...[
          const SizedBox(width: 8),
          widget.suffix!,
        ],
      ],
    );
  }
}
