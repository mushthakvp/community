import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/category.dart';

class CategoryGridWidget extends StatelessWidget {
  final List<Category> categories;
  final Function(Category) onCategorySelected;

  const CategoryGridWidget({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the height needed for the grid
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = 3;
    final crossAxisSpacing = 8.0;
    final mainAxisSpacing = 8.0;
    final childAspectRatio = 1.0;
    final horizontalPadding = 32.0;

    final availableWidth = screenWidth - horizontalPadding;
    final itemWidth =
        (availableWidth - (crossAxisSpacing * (crossAxisCount - 1))) /
        crossAxisCount;
    final itemHeight = itemWidth / childAspectRatio;

    final rowCount = (categories.length / crossAxisCount).ceil();
    final gridHeight =
        (rowCount * itemHeight) + ((rowCount - 1) * mainAxisSpacing);

    return SizedBox(
      height: gridHeight,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryItem(category);
        },
      ),
    );
  }

  Widget _buildCategoryItem(Category category) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onCategorySelected(category),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppConstants.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppConstants.appPrimaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: AppConstants.appPrimaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppConstants.appPrimaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  _getCategoryIcon(category.name),
                  size: 24,
                  color: AppConstants.appPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: CommonTextWidget(
                    text: category.name.replaceAll('&', '&\n'),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    align: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'motors':
        return Icons.directions_car;
      case 'classifieds':
        return Icons.category;
      case 'furniture & garden':
        return Icons.chair;
      case 'freshly grown':
        return Icons.eco;
      case 'property for sale':
        return Icons.home;
      case 'property for rent':
        return Icons.apartment;
      case 'community':
        return Icons.people;
      default:
        return Icons.apps;
    }
  }
}
