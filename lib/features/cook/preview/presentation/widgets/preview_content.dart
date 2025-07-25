import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/preview_controller.dart';
import 'recipe_description_section.dart';
import 'recipe_header.dart';
import 'recipe_image_section.dart';
import 'recipe_ingredients_section.dart';
import 'recipe_steps_section.dart';
import 'recipe_tabs_section.dart';
import 'recipe_video_section.dart';

class PreviewContent extends StatelessWidget {
  final Map<String, dynamic> recipeData;
  final PreviewController controller;

  const PreviewContent({
    super.key,
    required this.recipeData,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isTextRecipe = (recipeData['recipeType'] ?? 'text') == 'text';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          RecipeHeader(
            title: recipeData['title'] ?? '',
            cookingTime: recipeData['cookingTime'] ?? '',
          ),
          const SizedBox(height: 14),
          RecipeImageSection(imageUrl: recipeData['image'] ?? ''),
          const SizedBox(height: 20),
          RecipeDescriptionSection(
            description: recipeData['description'] ?? '',
          ),
          const SizedBox(height: 22),
          if (isTextRecipe) ...[
            RecipeTabsSection(controller: controller),
            const SizedBox(height: 22),
            _buildDynamicTextContent(),
          ] else ...[
            RecipeVideoSection(videoUrl: recipeData['video'] ?? ''),
          ],
          const SizedBox(height: 22),
        ],
      ),
    );
  }

  Widget _buildDynamicTextContent() {
    return Obx(() {
      if (controller.selectedTabIndex == 0) {
        return RecipeIngredientsSection(
          ingredients: recipeData['ingredients'] != null
              ? List<Map<String, dynamic>>.from(recipeData['ingredients'])
              : [],
        );
      } else {
        return RecipeStepsSection(
          steps: recipeData['steps'] != null
              ? List<Map<String, dynamic>>.from(recipeData['steps'])
              : [],
        );
      }
    });
  }
}
