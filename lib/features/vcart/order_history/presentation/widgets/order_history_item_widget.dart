import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/widgets/vcart_cached_image.dart';
import '../../domain/entities/order_history.dart';
import '../controllers/order_history_controller.dart';

class OrderHistoryItemWidget extends StatelessWidget {
  final OrderGroup orderGroup;
  final VCartOrderHistoryController controller;

  const OrderHistoryItemWidget({
    super.key,
    required this.orderGroup,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: VCartColors.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VCartColors.border.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          const Divider(color: VCartColors.border, height: 1),
          _buildOrderItems(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final firstItem = orderGroup.items.isNotEmpty
        ? orderGroup.items.first
        : null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order Placed",
                  style: TextStyle(
                    fontSize: 12,
                    color: VCartColors.textSecondary.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  orderGroup.orderDate ?? 'Unknown Date',
                  style: const TextStyle(
                    fontSize: 14,
                    color: VCartColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Order ID",
                style: TextStyle(
                  fontSize: 12,
                  color: VCartColors.textSecondary.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                firstItem?.orderId ?? 'N/A',
                style: const TextStyle(
                  fontSize: 14,
                  color: VCartColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: orderGroup.items.length,
      itemBuilder: (context, index) {
        final item = orderGroup.items[index];
        return _buildOrderItemCard(context, item);
      },
      separatorBuilder: (context, index) =>
          const Divider(color: VCartColors.border, height: 20),
    );
  }

  Widget _buildOrderItemCard(BuildContext context, OrderItem item) {
    return InkWell(
      onTap: () => _navigateToOrderDetails(context, item.orderId),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            VCartCachedImage(
              imageUrl: item.product?.image ?? '',
              height: 80,
              width: 80,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product?.name ?? 'Unknown Product',
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
                      _buildStatusChip(item.product?.status),
                      const Spacer(),
                      Text(
                        (item.product?.finalPrice ?? 0).formatPrice,
                        style: const TextStyle(
                          fontSize: 16,
                          color: VCartColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  void _navigateToOrderDetails(BuildContext context, String? orderId) {
    if (orderId != null) {
      context.push('/vcart/order-details/$orderId');
    }
  }
}
