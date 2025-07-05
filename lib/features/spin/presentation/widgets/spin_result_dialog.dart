import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/spin_entity.dart';

class SpinResultDialog extends StatelessWidget {
  final SpinEntity option;
  final bool isUnlimited;
  final VoidCallback onContinue;
  final VoidCallback? onSpinAgain;

  const SpinResultDialog({
    super.key,
    required this.option,
    this.isUnlimited = false,
    required this.onContinue,
    this.onSpinAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppConstants.appPrimaryColor.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppConstants.black.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppConstants.appPrimaryColor.withOpacity(0.3),
                    AppConstants.appPrimaryColor.withOpacity(0.1),
                  ],
                ),
              ),
              child: Icon(_getResultIcon(), color: _getResultColor(), size: 40),
            ),
            const SizedBox(height: 20),

            // Title
            CommonTextWidget(
              text: _getResultTitle(),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Subtitle
            if (_getResultSubtitle().isNotEmpty) ...[
              CommonTextWidget(
                text: _getResultSubtitle(),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
                align: TextAlign.center,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
            ],

            // Coupon Code Display
            if (option.hasCouponCode) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppConstants.appPrimaryColor.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CommonTextWidget(
                        text: option.couponCode!,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.appPrimaryColor,
                        align: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _copyCouponCode(context),
                      icon: const Icon(
                        Icons.copy,
                        color: AppConstants.appPrimaryColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Action Buttons
            if (isUnlimited && onSpinAgain != null)
              PrimaryButton(
                text: 'Spin Again',
                onPressed: onSpinAgain!,
                backgroundColor: AppConstants.appPrimaryColor,
                textColor: AppConstants.black,
                height: 48,
                width: double.infinity,
              )
            else
              PrimaryButton(
                text: 'Continue',
                onPressed: onContinue,
                backgroundColor: AppConstants.appPrimaryColor,
                textColor: AppConstants.black,
                height: 48,
                width: double.infinity,
              ),
          ],
        ),
      ),
    );
  }

  IconData _getResultIcon() {
    if (option.hasLoyaltyPoints) return Icons.stars;
    if (option.hasCouponCode) return Icons.local_offer;
    if (option.isBetterLuck) return Icons.sentiment_neutral;
    if (option.isSpinAgain) return Icons.refresh;
    return Icons.emoji_events;
  }

  Color _getResultColor() {
    if (option.isBetterLuck) return Colors.orange;
    return AppConstants.appPrimaryColor;
  }

  String _getResultTitle() {
    if (option.hasLoyaltyPoints) return 'Congratulations! You\'ve Won!';
    if (option.hasCouponCode) return 'You\'ve Won a Coupon!';
    if (option.isBetterLuck) return 'Better Luck Next Time';
    if (option.isSpinAgain) return 'Spin Again!';
    return 'Congratulations!';
  }

  String _getResultSubtitle() {
    if (option.hasLoyaltyPoints) {
      return 'You\'ve won ${option.loyaltyPoint} loyalty points. Keep spinning for more exciting prizes.';
    }
    if (option.hasCouponCode) {
      return 'Use this coupon code to get amazing discounts!';
    }
    if (option.isBetterLuck) {
      return 'You didn\'t win this time, but don\'t give up! Keep spinning the wheel for more chances to win exciting prizes.';
    }
    if (option.isSpinAgain) {
      return 'Lucky you! You get another chance to spin and win.';
    }
    return option.title;
  }

  void _copyCouponCode(BuildContext context) {
    if (option.couponCode != null) {
      Clipboard.setData(ClipboardData(text: option.couponCode!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coupon code copied to clipboard!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
