import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/widgets/vcart_button.dart';
import '../controllers/order_history_controller.dart';

class OrderHistoryFilterBottomSheet extends StatelessWidget {
  final VCartOrderHistoryController controller;

  const OrderHistoryFilterBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: VCartColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: VCartColors.border, width: 0.5),
          left: BorderSide(color: VCartColors.border, width: 0.5),
          right: BorderSide(color: VCartColors.border, width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildHeader(context),
          _buildYearList(),
          _buildActions(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: VCartColors.textSecondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            'Filter by Year',
            style: TextStyle(
              color: VCartColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close,
              color: VCartColors.textSecondary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearList() {
    return Obx(() {
      if (controller.availableYears.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'No years available',
            style: TextStyle(color: VCartColors.textSecondary, fontSize: 14),
          ),
        );
      }

      return Container(
        constraints: const BoxConstraints(maxHeight: 300),
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount:
              controller.availableYears.length + 1, // +1 for "All Years" option
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildYearTile(
                year: '',
                displayText: 'All Years',
                isSelected: controller.selectedYear.isEmpty,
              );
            }

            final year = controller.availableYears[index - 1];
            final isCurrentYear = year == DateTime.now().year;
            final displayText = isCurrentYear
                ? 'Current Year ($year)'
                : year.toString();

            return _buildYearTile(
              year: year.toString(),
              displayText: displayText,
              isSelected: controller.selectedYear == year.toString(),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
      );
    });
  }

  Widget _buildYearTile({
    required String year,
    required String displayText,
    required bool isSelected,
  }) {
    return ListTile(
      onTap: () => controller.setYearFilter(year),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected
              ? VCartColors.primary
              : VCartColors.border.withOpacity(0.3),
        ),
      ),
      tileColor: isSelected
          ? VCartColors.primary.withOpacity(0.1)
          : VCartColors.surface.withOpacity(0.3),
      title: Text(
        displayText,
        style: TextStyle(
          color: isSelected ? VCartColors.primary : VCartColors.textPrimary,
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: VCartColors.primary, size: 20)
          : const Icon(
              Icons.arrow_forward_ios,
              color: VCartColors.textSecondary,
              size: 16,
            ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: VCartButton(
              text: "Clear Filter",
              type: VCartButtonType.secondary,
              onPressed: () {
                controller.clearYearFilter();
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: VCartButton(
              text: "Apply Filter",
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
