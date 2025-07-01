import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/vizzle_entities.dart';
import 'sub_category_list_item.dart';

class SubCategoryList extends StatelessWidget {
  final String categoryName;
  final String categoryId;
  final List<SubCategoryEntity> subCategories;
  final Function(SubCategoryEntity) onSubCategoryTap;

  const SubCategoryList({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.subCategories,
    required this.onSubCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (subCategories.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      height: context.height,
      width: context.width,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: subCategories.length,
              separatorBuilder: (context, index) => Divider(
                color: AppConstants.white.withOpacity(0.3),
                thickness: 1,
                height: 0,
              ),
              itemBuilder: (context, index) {
                final sortedSubCategories = [...subCategories];
                sortedSubCategories.sort((a, b) => a.name.compareTo(b.name));
                final subCategory = sortedSubCategories[index];

                return SubCategoryListItem(
                  subCategory: subCategory,
                  onTap: () => onSubCategoryTap(subCategory),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 64,
            color: AppConstants.white.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const CommonTextWidget(
            text: 'No Sub Categories',
            color: AppConstants.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            align: TextAlign.center,
          ),
          const SizedBox(height: 8),
          CommonTextWidget(
            text: 'No subcategories found for this category',
            color: AppConstants.white.withOpacity(0.7),
            fontSize: 14,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
