import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/widgets/vcart_button.dart';
import '../../../core/widgets/vcart_loading.dart';
import '../../../shared/presentation/widgets/error_widget.dart';
import '../../../shared/presentation/widgets/maintenance_widget.dart';
import '../controllers/order_history_controller.dart';
import '../widgets/order_history_filter_bottom_sheet.dart';
import '../widgets/order_history_item_widget.dart';

class VCartOrderHistoryPage extends StatelessWidget {
  const VCartOrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VCartOrderHistoryController>();

    return Scaffold(
      backgroundColor: VCartColors.background,
      appBar: _buildAppBar(context, controller),
      body: Obx(() => _buildBody(context, controller)),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    VCartOrderHistoryController controller,
  ) {
    return AppBar(
      backgroundColor: VCartColors.background,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            border: Border.all(color: VCartColors.border, width: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back,
            size: 18,
            color: VCartColors.textPrimary,
          ),
        ),
      ),
      title: const Text(
        "Order History",
        style: TextStyle(
          color: VCartColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Obx(() => _buildFilterButton(context, controller)),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildFilterButton(
    BuildContext context,
    VCartOrderHistoryController controller,
  ) {
    final hasFilter = controller.selectedYear.isNotEmpty;

    return Stack(
      children: [
        VCartButton(
          text: "Filter",
          type: VCartButtonType.outline,
          icon: Icons.tune,
          onPressed: () => _showFilterBottomSheet(context, controller),
          width: 80,
          height: 36,
        ),
        if (hasFilter)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: VCartColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    VCartOrderHistoryController controller,
  ) {
    if (controller.isLoading && controller.orderGroups.isEmpty) {
      return const VCartLoading(size: 32);
    }

    if (controller.hasError && controller.orderGroups.isEmpty) {
      return VCartErrorWidget(
        message: controller.errorMessage,
        onRetry: () => controller.loadOrderHistory(refresh: true),
      );
    }

    if (controller.isEmpty) {
      return VCartMaintenanceWidget(
        imageUrl:
            'https://via.placeholder.com/200x200/2A2A2A/FFFFFF?text=No+Orders',
        title: 'Your Order History is Empty',
        subtitle:
            'Your order history will show here as soon as you make a purchase.',
        onPressed: () => context.go('/vcart/home'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.refreshOrderHistory(),
      color: VCartColors.primary,
      child: ListView.separated(
        controller: controller.scrollController,
        padding: context.defaultPadding,
        itemCount:
            controller.orderGroups.length + (controller.hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.orderGroups.length) {
            return _buildLoadMoreIndicator(controller);
          }

          final orderGroup = controller.orderGroups[index];
          return OrderHistoryItemWidget(
            orderGroup: orderGroup,
            controller: controller,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
      ),
    );
  }

  Widget _buildLoadMoreIndicator(VCartOrderHistoryController controller) {
    if (!controller.hasMoreData) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: controller.isLoadingMore
            ? const VCartLoading(size: 24)
            : const SizedBox.shrink(),
      ),
    );
  }

  void _showFilterBottomSheet(
    BuildContext context,
    VCartOrderHistoryController controller,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          OrderHistoryFilterBottomSheet(controller: controller),
    );
  }
}
