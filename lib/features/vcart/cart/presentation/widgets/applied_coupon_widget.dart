import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/widgets/vcart_button.dart';
import '../../domain/entities/coupon_data.dart';

class AppliedCouponWidget extends StatelessWidget {
  final CouponData couponData;
  final VoidCallback onRemove;
  final bool isLoading;

  const AppliedCouponWidget({
    super.key,
    required this.couponData,
    required this.onRemove,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VCartColors.success.withOpacity(0.1),
        border: Border.all(
          color: VCartColors.success.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildDiscountBadge(),
          const SizedBox(width: 16),
          Expanded(child: _buildCouponInfo()),
          _buildRemoveButton(),
        ],
      ),
    );
  }

  Widget _buildDiscountBadge() {
    return Container(
      height: 48,
      width: 48,
      decoration: const BoxDecoration(
        color: VCartColors.success,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          couponData.displayDiscount,
          style: const TextStyle(
            color: VCartColors.onPrimary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCouponInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          couponData.couponName,
          style: const TextStyle(
            color: VCartColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          "Coupon Applied",
          style: TextStyle(
            color: VCartColors.success,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRemoveButton() {
    return VCartButton(
      text: "",
      onPressed: isLoading ? null : onRemove,
      type: VCartButtonType.tertiary,
      isLoading: isLoading,
      width: 40,
      height: 40,
      icon: Icons.close,
    );
  }
}
