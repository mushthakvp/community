import 'package:flutter/material.dart';
import 'package:livera/features/vcart/core/router/v_cart_router_g.dart';

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
        // Removed the product count text display
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
    VCartRouterClassG.toVCartFilter(
      sectionId: controller.filterParams.sectionId,
      brandId: controller.filterParams.brandId,
    );
  }
}
