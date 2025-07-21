import 'package:flutter/material.dart';

import '../../../cart/domain/entities/cart_data.dart';
import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';

class OrderSummaryWidget extends StatelessWidget {
  final CartData cartData;

  const OrderSummaryWidget({super.key, required this.cartData});

  @override
  Widget build(BuildContext context) {
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
              _buildSummaryRow("Subtotal", cartData.subTotal.formatPrice),
              if (cartData.shippingCharge > 0)
                _buildSummaryRow(
                  "Shipping",
                  cartData.shippingCharge.formatPrice,
                ),
              if (cartData.tax > 0)
                _buildSummaryRow("Tax", cartData.tax.formatPrice),
              if (cartData.discount > 0)
                _buildSummaryRow(
                  "Discount",
                  "- ${cartData.discount.formatPrice}",
                  isDiscount: true,
                ),
              if (cartData.couponDiscount > 0)
                _buildSummaryRow(
                  "Coupon Discount",
                  "- ${cartData.couponDiscount.formatPrice}",
                  isDiscount: true,
                ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: VCartColors.border, height: 1),
              ),
              _buildSummaryRow(
                "Total",
                cartData.total.formatPrice,
                isBold: true,
              ),
            ],
          ),
        ),
      ],
    );
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
