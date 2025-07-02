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
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryItem(category);
      },
    );
  }

  Widget _buildCategoryItem(Category category) {
    return GestureDetector(
      onTap: () => onCategorySelected(category),
      child: Container(
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
            Icon(
              _getCategoryIcon(category.name),
              size: 40,
              color: AppConstants.appPrimaryColor,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CommonTextWidget(
                text: category.name.replaceAll('&', '&\n'),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                align: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ],
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
