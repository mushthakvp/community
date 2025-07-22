import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/widgets/vcart_button.dart';
import '../controllers/order_details_controller.dart';

class OrderTrackingWidget extends StatelessWidget {
  final VCartOrderDetailsController controller;

  const OrderTrackingWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final order = controller.order;
      if (order == null) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Track Order",
            style: TextStyle(
              color: VCartColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          VCartButton(
            text: "Track your order",
            icon: Icons.local_shipping_outlined,
            onPressed: () => _navigateToTracking(context, order.id),
            isExpanded: true,
            type: VCartButtonType.secondary,
          ),
        ],
      );
    });
  }

  void _navigateToTracking(BuildContext context, String? orderId) {
    if (orderId != null) {
      context.push('/vcart/order-tracking/$orderId');
    }
  }
}
