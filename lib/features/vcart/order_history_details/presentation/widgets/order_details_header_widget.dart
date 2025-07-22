import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livera/features/vcart/core/utils/vcart_extensions.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/widgets/vcart_cached_image.dart';
import '../controllers/order_details_controller.dart';

class OrderDetailsHeaderWidget extends StatelessWidget {
  final VCartOrderDetailsController controller;

  const OrderDetailsHeaderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final order = controller.order;
      if (order == null) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: VCartColors.surface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: VCartColors.border.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            VCartCachedImage(
              imageUrl: order.images?.first ?? '',
              height: 80,
              width: 80,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.productName ?? 'Unknown Product',
                    style: const TextStyle(
                      fontSize: 16,
                      color: VCartColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildStatusChip(order.orderStatus),
                      const SizedBox(width: 12),
                      _buildQuantityChip(order.quantity),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order.finalPrice.formatPrice,
                    style: const TextStyle(
                      fontSize: 18,
                      color: VCartColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatusChip(String? status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: controller.getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: controller.getStatusColor(status).withOpacity(0.3),
        ),
      ),
      child: Text(
        controller.getStatusDisplayName(status),
        style: TextStyle(
          fontSize: 12,
          color: controller.getStatusColor(status),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildQuantityChip(num? quantity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: VCartColors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: VCartColors.border.withOpacity(0.3)),
      ),
      child: Text(
        'Qty: ${quantity ?? 0}',
        style: const TextStyle(
          fontSize: 12,
          color: VCartColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
