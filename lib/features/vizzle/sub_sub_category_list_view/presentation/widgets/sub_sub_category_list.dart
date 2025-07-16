import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/vizzle_entities.dart';
import 'sub_sub_category_list_item.dart';

class SubSubCategoryList extends StatelessWidget {
  final List<SubSubCategoryEntity> subSubCategories;
  final Function(SubSubCategoryEntity) onSubSubCategoryTap;

  const SubSubCategoryList({
    super.key,
    required this.subSubCategories,
    required this.onSubSubCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (subSubCategories.isEmpty) {
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
              itemCount: subSubCategories.length,
              separatorBuilder: (context, index) => Divider(
                color: AppConstants.white.withOpacity(0.3),
                thickness: 1,
                height: 0,
              ),
              itemBuilder: (context, index) {
                final sortedSubSubCategories = [...subSubCategories];
                sortedSubSubCategories.sort((a, b) => a.name.compareTo(b.name));
                final subSubCategory = sortedSubSubCategories[index];

                return SubSubCategoryListItem(
                  subSubCategory: subSubCategory,
                  onTap: () => onSubSubCategoryTap(subSubCategory),
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
            text: 'No sub-subcategories found for this category',
            color: AppConstants.white.withOpacity(0.7),
            fontSize: 14,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
