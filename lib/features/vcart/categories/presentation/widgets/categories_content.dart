import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../controllers/categories_controller.dart';
import 'categories_grid.dart';
import 'subcategories_grid.dart';

class CategoriesContent extends StatelessWidget {
  final VCartCategoriesController controller;

  const CategoriesContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: context.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoriesSection(),
              _buildSubCategoriesSection(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Obx(() {
      return Skeletonizer(
        enabled: controller.isCategoryLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.categories.isNotEmpty)
              FadeInLeftBig(
                child: Text(
                  controller.sections.isNotEmpty
                      ? controller
                            .sections[controller.selectedSectionIndex]
                            .name
                      : "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: VCartColors.primary,
                  ),
                ),
              ),
            const SizedBox(height: 15),
            if (controller.categories.isNotEmpty)
              _buildSectionTitle("Categories"),
            const SizedBox(height: 20),
            CategoriesGrid(controller: controller),
          ],
        ),
      );
    });
  }

  Widget _buildSubCategoriesSection() {
    return Obx(() {
      if (controller.selectedCategoryName.isEmpty) {
        return const SizedBox.shrink();
      }

      return Skeletonizer(
        enabled: controller.isSubCategoryLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            if (controller.subCategories.isNotEmpty)
              FadeInLeft(
                child: Text(
                  controller.selectedCategoryName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: VCartColors.primary,
                  ),
                ),
              ),
            const SizedBox(height: 15),
            if (controller.subCategories.isNotEmpty)
              _buildSectionTitle("Sub Categories"),
            const SizedBox(height: 20),
            SubCategoriesGrid(controller: controller),
          ],
        ),
      );
    });
  }

  Widget _buildSectionTitle(String title) {
    return FadeInLeft(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: VCartColors.textSecondary.withOpacity(0.4),
        ),
      ),
    );
  }
}
