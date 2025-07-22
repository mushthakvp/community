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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildHeader(context),
          _buildYearList(),
          _buildActions(context),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 48,
      height: 4,
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      decoration: BoxDecoration(
        color: VCartColors.textSecondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 16, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: VCartColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.tune, color: VCartColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Filter by Year',
              style: TextStyle(
                color: VCartColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: VCartColors.surface.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.close,
                color: VCartColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearList() {
    return Obx(() {
      if (controller.availableYears.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(48),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VCartColors.surface.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_today_outlined,
                  size: 32,
                  color: VCartColors.textSecondary.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No years available',
                style: TextStyle(
                  color: VCartColors.textSecondary.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Start shopping to see filters',
                style: TextStyle(
                  color: VCartColors.textSecondary.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        constraints: const BoxConstraints(maxHeight: 350),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: controller.availableYears.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildYearTile(
                year: '',
                displayText: 'All Years',
                subtitle: 'Show orders from all years',
                isSelected: controller.selectedYear.isEmpty,
                icon: Icons.all_inclusive,
              );
            }

            final year = controller.availableYears[index - 1];
            final isCurrentYear = year == DateTime.now().year;
            final displayText = year.toString();
            final subtitle = isCurrentYear ? 'Current year' : '$year orders';

            return _buildYearTile(
              year: year.toString(),
              displayText: displayText,
              subtitle: subtitle,
              isSelected: controller.selectedYear == year.toString(),
              icon: isCurrentYear ? Icons.today : Icons.calendar_month,
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 12),
        ),
      );
    });
  }

  Widget _buildYearTile({
    required String year,
    required String displayText,
    required String subtitle,
    required bool isSelected,
    required IconData icon,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.setYearFilter(year),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected
                  ? VCartColors.primary.withOpacity(0.08)
                  : VCartColors.surface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? VCartColors.primary.withOpacity(0.3)
                    : VCartColors.border.withOpacity(0.2),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? VCartColors.primary.withOpacity(0.15)
                        : VCartColors.surface.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isSelected
                        ? VCartColors.primary
                        : VCartColors.textSecondary.withOpacity(0.8),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayText,
                        style: TextStyle(
                          color: isSelected
                              ? VCartColors.primary
                              : VCartColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: isSelected
                              ? VCartColors.primary.withOpacity(0.7)
                              : VCartColors.textSecondary.withOpacity(0.7),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: isSelected ? 0 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? VCartColors.primary
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSelected ? Icons.check : Icons.arrow_forward_ios,
                      size: isSelected ? 16 : 14,
                      color: isSelected
                          ? Colors.white
                          : VCartColors.textSecondary.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: VCartButton(
                text: "Clear Filter",
                type: VCartButtonType.secondary,
                onPressed: () {
                  controller.clearYearFilter();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 48,
              child: VCartButton(
                text: "Apply Filter",
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
