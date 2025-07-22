import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
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
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Obx(() => _buildFilterButton(context, controller)),
        ),
      ],
    );
  }

  Widget _buildFilterButton(
    BuildContext context,
    VCartOrderHistoryController controller,
  ) {
    final hasFilter = controller.selectedYear.isNotEmpty;

    return Stack(
      alignment: Alignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showFilterBottomSheet(context, controller),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: hasFilter
                    ? VCartColors.primary.withOpacity(0.1)
                    : VCartColors.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasFilter
                      ? VCartColors.primary.withOpacity(0.3)
                      : VCartColors.border.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tune,
                    size: 18,
                    color: hasFilter
                        ? VCartColors.primary
                        : VCartColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    hasFilter ? controller.selectedYear : 'Filter',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: hasFilter
                          ? VCartColors.primary
                          : VCartColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasFilter)
          Positioned(
            top: 6,
            right: 6,
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

    return Column(
      children: [
        // Active filter indicator
        Obx(() => _buildActiveFilterChip(controller)),
        // Orders list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => controller.refreshOrderHistory(),
            color: VCartColors.primary,
            child: ListView.separated(
              controller: controller.scrollController,
              padding: context.defaultPadding,
              itemCount:
                  controller.orderGroups.length +
                  (controller.hasMoreData ? 1 : 0),
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
          ),
        ),
      ],
    );
  }

  Widget _buildActiveFilterChip(VCartOrderHistoryController controller) {
    if (controller.selectedYear.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: VCartColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: VCartColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.filter_alt, size: 18, color: VCartColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Showing orders from ${controller.selectedYear}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: VCartColors.primary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => controller.clearYearFilter(),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: VCartColors.primary.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 14,
                        color: VCartColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) =>
          OrderHistoryFilterBottomSheet(controller: controller),
    );
  }
}
