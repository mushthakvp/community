import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/utils/vcart_helpers.dart';
import '../../domain/entities/cart_data.dart';

class CartSummaryWidget extends StatelessWidget {
  final CartData cartData;

  const CartSummaryWidget({super.key, required this.cartData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryItem(
          title: "Subtotal",
          amount: VCartHelpers.calculateProductPrice(
            cartData.subTotal,
            cartData.commission,
          ).formatPrice,
        ),
        if (cartData.shippingCharge > 0)
          _buildSummaryItem(
            title: "Shipping Charges",
            amount: cartData.shippingCharge.formatPrice,
          ),
        if (cartData.tax > 0)
          _buildSummaryItem(title: "Tax", amount: cartData.tax.formatPrice),
        if (cartData.discount > 0)
          _buildSummaryItem(
            title: "Discount",
            amount: "- ${cartData.discount.formatPrice}",
            isDiscount: true,
          ),
        if (cartData.couponDiscount > 0)
          _buildSummaryItem(
            title: "Coupon Discount",
            amount: "- ${cartData.couponDiscount.formatPrice}",
            isDiscount: true,
          ),
        const SizedBox(height: 16),
        _buildDivider(),
        const SizedBox(height: 8),
        _buildSummaryItem(
          title: "Total",
          amount: cartData.total.formatPrice,
          isBold: true,
        ),
      ],
    );
  }

  Widget _buildSummaryItem({
    required String title,
    required String amount,
    bool isBold = false,
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: VCartColors.textPrimary,
              fontSize: isBold ? 18 : 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: isDiscount ? VCartColors.success : VCartColors.textPrimary,
              fontSize: isBold ? 18 : 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return SizedBox(
      height: 1,
      width: double.infinity,
      child: CustomPaint(
        painter: DottedLinePainter(
          color: VCartColors.border.withOpacity(0.5),
          dotWidth: 6.5,
          dotHeight: 1,
        ),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double dotWidth;
  final double dotHeight;

  DottedLinePainter({
    required this.color,
    required this.dotWidth,
    required this.dotHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = dotHeight
      ..style = PaintingStyle.stroke;

    final gap = dotWidth * 2;
    for (double i = 0; i < size.width; i += gap) {
      canvas.drawLine(Offset(i, 0), Offset(i + dotWidth, 0), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
