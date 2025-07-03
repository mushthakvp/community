import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/spin_option_entity.dart';
import '../../domain/entities/spin_result_entity.dart';

class SpinResultDialog extends StatefulWidget {
  final SpinResultEntity result;
  final VoidCallback? onSpinAgain;
  final VoidCallback? onClose;
  final bool canSpinAgain;

  const SpinResultDialog({
    super.key,
    required this.result,
    this.onSpinAgain,
    this.onClose,
    this.canSpinAgain = false,
  });

  @override
  State<SpinResultDialog> createState() => _SpinResultDialogState();
}

class _SpinResultDialogState extends State<SpinResultDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
  }

  void _startAnimations() {
    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _buildDialogContent(),
        ),
      ),
    );
  }

  Widget _buildDialogContent() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildHeader(), _buildContent(), _buildActions()],
      ),
    );
  }

  Widget _buildHeader() {
    final isWinning = widget.result.isWinning;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isWinning
              ? [Colors.green.shade400, Colors.green.shade600]
              : [Colors.orange.shade400, Colors.orange.shade600],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Animation
          SizedBox(
            height: 80,
            child: isWinning
                ? Lottie.asset(
                    'assets/animations/celebration.json',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.sentiment_neutral, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 16),

          // Title
          CommonTextWidget(
            text: isWinning ? 'Congratulations!' : 'Better Luck Next Time!',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            align: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Subtitle
          CommonTextWidget(
            text: _getResultSubtitle(),
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Reward display
          _buildRewardDisplay(),

          const SizedBox(height: 20),

          // Additional info
          if (widget.result.spinOption.description.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: CommonTextWidget(
                text: widget.result.spinOption.description,
                fontSize: 14,
                color: Colors.grey.shade700,
                align: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRewardDisplay() {
    final option = widget.result.spinOption;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: option.rewardColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: option.rewardColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: option.rewardColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(option.rewardIcon, color: option.rewardColor, size: 30),
          ),

          const SizedBox(height: 16),

          // Reward text
          CommonTextWidget(
            text: option.rewardDisplayText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: option.rewardColor,
            align: TextAlign.center,
          ),

          // Coupon code (if applicable)
          if (option.couponCode != null) ...[
            const SizedBox(height: 16),
            _buildCouponCodeDisplay(option.couponCode!),
          ],
        ],
      ),
    );
  }

  Widget _buildCouponCodeDisplay(String couponCode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CommonTextWidget(
              text: couponCode,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          GestureDetector(
            onTap: () => _copyCouponCode(couponCode),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.copy, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Primary action
          if (widget.canSpinAgain && widget.onSpinAgain != null)
            PrimaryButton(
              text: 'Spin Again',
              onPressed: widget.onSpinAgain!,
              backgroundColor: AppConstants.appPrimaryColor,
              textColor: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 50,
              width: double.infinity,
              borderRadius: 12,
              prefix: const Icon(Icons.refresh, color: Colors.white, size: 20),
            ),

          if (widget.canSpinAgain && widget.onSpinAgain != null)
            const SizedBox(height: 12),

          // Secondary action
          PrimaryButton(
            text: widget.canSpinAgain ? 'Close' : 'Got It!',
            onPressed: () {
              Navigator.of(context).pop();
              widget.onClose?.call();
            },
            backgroundColor: Colors.transparent,
            borderColor: Colors.grey.shade300,
            textColor: Colors.grey.shade700,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 50,
            width: double.infinity,
            borderRadius: 12,
          ),
        ],
      ),
    );
  }

  String _getResultSubtitle() {
    final option = widget.result.spinOption;

    switch (option.rewardType) {
      case SpinRewardType.loyaltyPoints:
        return 'You earned ${option.loyaltyPoints} loyalty points!';
      case SpinRewardType.coupon:
        return 'You won an exclusive coupon code!';
      case SpinRewardType.gift:
        return 'You won a special gift!';
      case SpinRewardType.discount:
        return 'You got a discount on your next purchase!';
      case SpinRewardType.extraSpin:
        return 'You earned an extra spin!';
      case SpinRewardType.betterLuck:
        return 'Don\'t give up, try again soon!';
    }
  }

  void _copyCouponCode(String couponCode) {
    Clipboard.setData(ClipboardData(text: couponCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Coupon code "$couponCode" copied to clipboard!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
