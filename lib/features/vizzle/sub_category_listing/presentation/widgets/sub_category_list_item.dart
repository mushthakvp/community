// lib/features/vizzle/sub_category_listing/presentation/widgets/sub_category_list_item.dart
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/vizzle_entities.dart';

class SubCategoryListItem extends StatelessWidget {
  final SubCategoryEntity subCategory;
  final VoidCallback onTap;

  const SubCategoryListItem({
    super.key,
    required this.subCategory,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget(
                    text: subCategory.name.capitalizeFirstLetter(),
                    color: AppConstants.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  if (subCategory.hasSubSubCategories) ...[
                    const SizedBox(height: 4),
                    CommonTextWidget(
                      text:
                          '${subCategory.subSubCategories.length} items available',
                      color: AppConstants.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ],
                ],
              ),
            ),
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
}
