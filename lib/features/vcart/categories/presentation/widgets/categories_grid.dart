import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/utils/vcart_helpers.dart';
import '../controllers/categories_controller.dart';

class CategoriesGrid extends StatelessWidget {
  final VCartCategoriesController controller;

  const CategoriesGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: VCartHelpers.calculateChildAspectRatio(
          context.screenWidth,
          context.screenHeight,
          multiplier: 0.29,
        ),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => _buildCategoryItem(context, index),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    final category = controller.categories[index];

    return GestureDetector(
      onTap: () => controller.onCategoryTap(category),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeInDownBig(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: VCartColors.surface,
                border: Border.all(color: VCartColors.border),
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
          ),
          const SizedBox(height: 10),
          FadeInDownBig(
            child: Text(
              VCartHelpers.truncateText(category.name, 20),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: VCartColors.textPrimary.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
