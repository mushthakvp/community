import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/vcart_colors.dart';
import '../controllers/product_listing_controller.dart';
import 'sort_bottom_sheet.dart';

class SortFilterBar extends StatelessWidget {
  final VCartProductListingController controller;

  const SortFilterBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: () => _showSortBottomSheet(context),
          icon: const Icon(Icons.sort, color: VCartColors.textPrimary),
          label: const Text(
            'Sort',
            style: TextStyle(color: VCartColors.textPrimary),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: VCartColors.border),
          ),
        ),
        const Spacer(),
        Obx(
          () => Text(
            '${controller.productCount} Products',
            style: const TextStyle(
              color: VCartColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: () => _navigateToFilter(context),
          icon: const Icon(Icons.tune, color: VCartColors.textPrimary),
          label: const Text(
            'Filter',
            style: TextStyle(color: VCartColors.textPrimary),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: VCartColors.border),
          ),
        ),
      ],
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SortBottomSheet(controller: controller),
    );
  }

  void _navigateToFilter(BuildContext context) {
    Get.toNamed('/filter', arguments: controller.filterParams);
  }
}
