import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/vcart_colors.dart';
import '../controllers/order_details_controller.dart';

class OrderShippingAddressWidget extends StatelessWidget {
  final VCartOrderDetailsController controller;

  const OrderShippingAddressWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final shippingAddress = controller.shippingAddress;
      if (shippingAddress == null) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Shipping Address",
            style: TextStyle(
              color: VCartColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: VCartColors.surface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: VCartColors.border.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: VCartColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        shippingAddress.displayTitle,
                        style: const TextStyle(
                          color: VCartColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  shippingAddress.name ?? '',
                  style: const TextStyle(
                    color: VCartColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                if (shippingAddress.phone?.isNotEmpty == true)
                  Text(
                    shippingAddress.phone!,
                    style: const TextStyle(
                      color: VCartColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  shippingAddress.formattedAddress,
                  style: TextStyle(
                    color: VCartColors.textSecondary.withOpacity(0.8),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
