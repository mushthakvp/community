import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/vizzle_entities.dart';

class SubSubCategoryListItem extends StatelessWidget {
  final SubSubCategoryEntity subSubCategory;
  final VoidCallback onTap;

  const SubSubCategoryListItem({
    super.key,
    required this.subSubCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Row(
          children: [
            // Category Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppConstants.appPrimaryColor.withOpacity(0.3),
                ),
              ),
              child: Icon(
                _getCategoryIcon(subSubCategory.name),
                color: AppConstants.appPrimaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Category Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget(
                    text: subSubCategory.name.capitalizeFirstLetter(),
                    color: AppConstants.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  if (subSubCategory.hasSubItems) ...[
                    const SizedBox(height: 4),
                    CommonTextWidget(
                      text: '${subSubCategory.subItems.length} items available',
                      color: AppConstants.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ],
                ],
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              color: AppConstants.white.withOpacity(0.6),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();

    if (name.contains('apartment') || name.contains('flat')) {
      return Icons.apartment;
    } else if (name.contains('house') || name.contains('villa')) {
      return Icons.house;
    } else if (name.contains('office') || name.contains('commercial')) {
      return Icons.business;
    } else if (name.contains('land') || name.contains('plot')) {
      return Icons.landscape;
    } else if (name.contains('car') || name.contains('auto')) {
      return Icons.directions_car;
    } else if (name.contains('bike') || name.contains('motorcycle')) {
      return Icons.two_wheeler;
    } else if (name.contains('furniture')) {
      return Icons.chair;
    } else if (name.contains('electronics')) {
      return Icons.devices;
    } else if (name.contains('fashion') || name.contains('clothing')) {
      return Icons.checkroom;
    } else if (name.contains('mobile') || name.contains('phone')) {
      return Icons.smartphone;
    } else if (name.contains('laptop') || name.contains('computer')) {
      return Icons.laptop;
    } else if (name.contains('book')) {
      return Icons.book;
    } else if (name.contains('sport') || name.contains('fitness')) {
      return Icons.sports;
    } else if (name.contains('toy') || name.contains('game')) {
      return Icons.toys;
    } else if (name.contains('job') || name.contains('work')) {
      return Icons.work;
    } else if (name.contains('service')) {
      return Icons.room_service;
    } else {
      return Icons.category;
    }
  }
}
