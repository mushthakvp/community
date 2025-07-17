import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:livera/features/vcart/core/utils/vcart_extensions.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/constants/vcart_constants.dart';
import '../../../core/utils/vcart_helpers.dart';
import '../../domain/entities/category.dart';

class CategoryGrid extends StatelessWidget {
  final List<Category> categories;
  final Function(Category) onCategoryTap;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverPadding(
      padding: context.horizontalPadding,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: VCartConstants.categoriesPerRow,
          mainAxisSpacing: VCartConstants.defaultPadding,
          crossAxisSpacing: VCartConstants.defaultPadding,
          childAspectRatio: VCartHelpers.calculateChildAspectRatio(
            context.screenWidth,
            context.screenHeight,
            multiplier: 0.24,
          ),
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final category = categories[index];
          return CategoryItem(
            category: category,
            onTap: () => onCategoryTap(category),
          );
        }, childCount: categories.length),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryItem({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: VCartColors.borderLight, width: 1),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: category.imageUrl.orPlaceholder,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: VCartColors.surface,
                  child: const Icon(
                    Icons.category_outlined,
                    color: VCartColors.textSecondary,
                    size: 24,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: VCartColors.surface,
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: VCartColors.textSecondary,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            VCartHelpers.truncateText(category.name, 15),
            style: const TextStyle(
              color: VCartColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
