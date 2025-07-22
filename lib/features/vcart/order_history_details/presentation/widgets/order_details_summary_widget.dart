import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../controllers/order_details_controller.dart';

class OrderDetailsSummaryWidget extends StatelessWidget {
  final VCartOrderDetailsController controller;

  const OrderDetailsSummaryWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final order = controller.order;
      if (order == null) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Order Summary",
            style: TextStyle(
              color: VCartColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: VCartColors.surface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: VCartColors.border.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                _buildSummaryRow("Subtotal", order.subtotal.formatPrice),
                if (order.taxAmount > 0)
                  _buildSummaryRow("Tax", order.taxAmount.formatPrice),
                if (order.discountAmount > 0)
                  _buildSummaryRow(
                    "Discount",
                    "- ${order.discountAmount.formatPrice}",
                    isDiscount: true,
                  ),
                if (order.couponDiscountAmount > 0)
                  _buildSummaryRow(
                    "Coupon Discount",
                    "- ${order.couponDiscountAmount.formatPrice}",
                    isDiscount: true,
                  ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: VCartColors.border, height: 1),
                ),
                _buildSummaryRow(
                  "Total",
                  order.grandTotal.formatPrice,
                  isBold: true,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSummaryRow(
    String label,
    String amount, {
    bool isBold = false,
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: VCartColors.textPrimary,
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: isDiscount ? VCartColors.success : VCartColors.textPrimary,
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
