import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/constants/vcart_constants.dart';
import '../controllers/product_listing_controller.dart';

class SortBottomSheet extends StatelessWidget {
  final VCartProductListingController controller;

  const SortBottomSheet({super.key, required this.controller});

  static const List<String> _sortOptions = [
    'Popularity',
    'Price - Low to High',
    'Price - High to Low',
    'Newest First',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: VCartColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(VCartConstants.defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sort by',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: VCartColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            _sortOptions.length,
            (index) => _buildSortOption(_sortOptions[index]),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSortOption(String option) {
    return Obx(() {
      final isSelected = controller.tempSelectedSortOption == option;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(VCartConstants.defaultRadius),
          color: VCartColors.backgroundOpacity(0.3),
          border: Border.all(
            color: isSelected ? VCartColors.primary : VCartColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: ListTile(
          title: Text(
            option,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isSelected ? VCartColors.primary : VCartColors.textPrimary,
            ),
          ),
          trailing: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? VCartColors.primary : VCartColors.border,
                width: 2,
              ),
            ),
            child: isSelected
                ? Container(
                    margin: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: VCartColors.primary,
                    ),
                  )
                : null,
          ),
          onTap: () {
            controller.setSelectedSortOption(option, Get.context!);
            Navigator.pop(Get.context!);
          },
        ),
      );
    });
  }
}
