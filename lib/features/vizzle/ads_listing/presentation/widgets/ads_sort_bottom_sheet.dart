import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/ads_filter_entity.dart';

class AdsSortBottomSheet extends StatelessWidget {
  final AdsFilterSort currentSort;
  final Function(AdsFilterSort) onSortChanged;

  const AdsSortBottomSheet({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      (AdsFilterSort.newest, 'Newest First', Icons.schedule),
      (AdsFilterSort.oldest, 'Oldest First', Icons.history),
      (AdsFilterSort.priceLowToHigh, 'Price: Low to High', Icons.arrow_upward),
      (
        AdsFilterSort.priceHighToLow,
        'Price: High to Low',
        Icons.arrow_downward,
      ),
      (AdsFilterSort.featured, 'Featured First', Icons.star),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppConstants.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const CommonTextWidget(
            text: 'Sort By',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppConstants.white,
          ),

          const SizedBox(height: 20),

          ...sortOptions.map((option) {
            final (sort, title, icon) = option;
            final isSelected = currentSort == sort;

            return GestureDetector(
              onTap: () {
                onSortChanged(sort);
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: isSelected
                          ? AppConstants.appPrimaryColor
                          : AppConstants.white.withOpacity(0.6),
                      size: 20,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommonTextWidget(
                        text: title,
                        color: isSelected
                            ? AppConstants.appPrimaryColor
                            : AppConstants.white,
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check,
                        color: AppConstants.appPrimaryColor,
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
