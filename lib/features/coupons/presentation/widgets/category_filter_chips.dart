// lib/features/coupons/presentation/widgets/category_filter_chips.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/coupon_provider.dart';

class CategoryFilterChips extends StatelessWidget {
  const CategoryFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CouponProvider>(
      builder: (context, provider, child) {
        if (provider.categories.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: provider.categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = provider.categories[index];
              final isSelected = category.id == provider.selectedCategoryId;

              return GestureDetector(
                onTap: () => provider.selectCategory(category.id),
                child: AnimatedContainer(
                  duration: AppConstants.defaultAnimationDuration,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppConstants.appPrimaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected
                          ? AppConstants.appPrimaryColor
                          : AppConstants.white.withOpacity(0.3),
                    ),
                  ),
                  child: CommonTextWidget(
                    text: category.name,
                    color: isSelected ? AppConstants.black : AppConstants.white,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
