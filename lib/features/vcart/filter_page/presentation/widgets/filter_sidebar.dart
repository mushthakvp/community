import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../controllers/filter_page_controller.dart';

class FilterSidebar extends StatelessWidget {
  final VCartFilterPageController controller;

  const FilterSidebar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth * 0.35,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [VCartColors.surface, Color(0xFF1F1F1F)],
          stops: [0, 0.5],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Obx(() {
        return Column(
          children: [
            _buildFilterOption(
              context: context,
              title: "Price",
              index: 0,
              isSelected:
                  controller.filterState.minPrice != null &&
                  controller.filterState.maxPrice != null,
              selectedCount: 1,
            ),
            _buildFilterOption(
              context: context,
              title: "Brand",
              index: 1,
              isSelected: controller.filterState.selectedBrands.isNotEmpty,
              selectedCount: controller.filterState.selectedBrands.length,
            ),
            _buildFilterOption(
              context: context,
              title: "Size",
              index: 2,
              isSelected: controller.filterState.selectedSizes.isNotEmpty,
              selectedCount: controller.filterState.selectedSizes.length,
            ),
            _buildFilterOption(
              context: context,
              title: "Color",
              index: 3,
              isSelected: controller.filterState.selectedColors.isNotEmpty,
              selectedCount: controller.filterState.selectedColors.length,
            ),
            _buildFilterOption(
              context: context,
              title: "Offer",
              index: 4,
              isSelected: controller.filterState.selectedOffers.isNotEmpty,
              selectedCount: controller.filterState.selectedOffers.length,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFilterOption({
    required BuildContext context,
    required String title,
    required int index,
    required bool isSelected,
    required int selectedCount,
  }) {
    final isCurrentSelected = controller.selectedFilterIndex == index;

    return GestureDetector(
      onTap: () => controller.changeFilterIndex(index),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: context.screenHeight * 0.02,
          horizontal: context.screenWidth * 0.04,
        ),
        decoration: BoxDecoration(
          gradient: isCurrentSelected
              ? const LinearGradient(
                  colors: [VCartColors.surface, Color(0xFF2A2A2A)],
                  stops: [0, 1],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                )
              : null,
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isCurrentSelected
                    ? VCartColors.primary
                    : VCartColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (isSelected)
              CircleAvatar(
                radius: 10,
                backgroundColor: VCartColors.primary,
                child: Text(
                  selectedCount.toString(),
                  style: const TextStyle(
                    color: VCartColors.onPrimary,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
