import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/utils/vcart_helpers.dart';
import '../controllers/categories_controller.dart';

class SubCategoriesGrid extends StatelessWidget {
  final VCartCategoriesController controller;

  const SubCategoriesGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.subCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.subCategories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: VCartHelpers.calculateChildAspectRatio(
          context.screenWidth,
          context.screenHeight,
          multiplier: 0.30,
        ),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => _buildSubCategoryItem(context, index),
    );
  }

  Widget _buildSubCategoryItem(BuildContext context, int index) {
    final subCategory = controller.subCategories[index];

    return GestureDetector(
      onTap: () => controller.onSubCategoryTap(subCategory),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeInDownBig(
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: VCartColors.surface,
                border: Border.all(color: VCartColors.border),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: subCategory.imageUrl.orPlaceholder,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: VCartColors.surface,
                    child: const Icon(
                      Icons.category_outlined,
                      color: VCartColors.textSecondary,
                      size: 20,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: VCartColors.surface,
                    child: const Icon(
                      Icons.broken_image_outlined,
                      color: VCartColors.textSecondary,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          FadeInDownBig(
            child: Text(
              VCartHelpers.truncateText(subCategory.name, 20),
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
