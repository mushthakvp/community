import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/widgets/vcart_button.dart';
import '../../domain/entities/coupon.dart';

class CouponItemWidget extends StatelessWidget {
  final Coupon coupon;
  final bool isApplied;
  final bool isLoading;
  final VoidCallback onApply;

  const CouponItemWidget({
    super.key,
    required this.coupon,
    required this.isApplied,
    required this.isLoading,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isApplied
              ? VCartColors.success.withOpacity(0.5)
              : VCartColors.border,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isApplied
            ? VCartColors.success.withOpacity(0.05)
            : VCartColors.background,
      ),
      child: Column(
        children: [
          _buildCouponHeader(context),
          const SizedBox(height: 12),
          _buildCouponDescription(),
          const SizedBox(height: 8),
          _buildCouponMetadata(),
        ],
      ),
    );
  }

  Widget _buildCouponHeader(BuildContext context) {
    return Row(
      children: [
        _buildDiscountBadge(),
        SizedBox(width: context.screenWidth * 0.04),
        Expanded(child: _buildCouponInfo()),
        _buildApplyButton(),
      ],
    );
  }

  Widget _buildDiscountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: VCartColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        coupon.displayDiscount,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: VCartColors.onPrimary,
        ),
      ),
    );
  }

  Widget _buildCouponInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          coupon.couponName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: VCartColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Remaining ${coupon.remainingUsers} users",
          style: const TextStyle(
            fontSize: 12,
            color: VCartColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildApplyButton() {
    return VCartButton(
      text: isApplied ? 'Applied' : "Apply",
      onPressed: isApplied || !coupon.hasRemainingUses ? null : onApply,
      isLoading: isLoading,
      type: isApplied ? VCartButtonType.secondary : VCartButtonType.primary,
      width: 80,
      height: 36,
    );
  }

  Widget _buildCouponDescription() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        coupon.description,
        style: const TextStyle(
          fontSize: 13,
          color: VCartColors.textSecondary,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildCouponMetadata() {
    return Row(
      children: [
        if (coupon.minimumPrice > 0) ...[
          Icon(
            Icons.info_outline,
            size: 14,
            color: VCartColors.textSecondary.withOpacity(0.7),
          ),
          const SizedBox(width: 4),
          Text(
            "Min. order ${coupon.minimumPrice.formatPriceWithoutDecimal}",
            style: TextStyle(
              fontSize: 11,
              color: VCartColors.textSecondary.withOpacity(0.7),
            ),
          ),
          const Spacer(),
        ],
        Text(
          coupon.validityText,
          style: TextStyle(
            fontSize: 11,
            color: VCartColors.textSecondary.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
