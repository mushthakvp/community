import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../controllers/recipe_type_controller.dart';
import '../widgets/common/recipe_app_bar.dart';
import '../widgets/common/recipe_button.dart';
import '../widgets/recipe_type_selection/recipe_type_option.dart';

class RecipeTypeSelectionPage extends StatelessWidget {
  const RecipeTypeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecipeTypeController());

    return Scaffold(
      backgroundColor: AppConstants.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const RecipeAppBar(title: 'Add recipe', showBackButton: true),
              const SizedBox(height: 32),
              _buildRecipeImage(),
              const SizedBox(height: 38),
              _buildMethodSelectionTitle(),
              const SizedBox(height: 18),
              _buildRecipeTypeOptions(controller),
              const Spacer(),
              _buildActionButtons(controller, context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeImage() {
    return const Align(
      alignment: Alignment.center,
      child: Icon(Icons.restaurant_menu, size: 200, color: Colors.amber),
    );
  }

  Widget _buildMethodSelectionTitle() {
    return const Text(
      'Select method:',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildRecipeTypeOptions(RecipeTypeController controller) {
    return Obx(
      () => Column(
        children: [
          RecipeTypeOption(
            title: 'Text Recipe',
            type: 'text',
            isSelected: controller.selectedType == 'text',
            onTap: () => controller.selectRecipeType('text'),
          ),
          const SizedBox(height: 15),
          RecipeTypeOption(
            title: 'Video Recipe',
            type: 'video',
            isSelected: controller.selectedType == 'video',
            onTap: () => controller.selectRecipeType('video'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    RecipeTypeController controller,
    BuildContext context,
  ) {
    return Obx(
      () => Row(
        children: [
          _buildCancelButton(controller),
          const SizedBox(width: 10),
          _buildNextButton(controller, context),
        ],
      ),
    );
  }

  Widget _buildCancelButton(RecipeTypeController controller) {
    return Expanded(
      child: RecipeButton(
        text: 'Cancel',
        onPressed: () {
          controller.reset();
          Get.back();
        },
        backgroundColor: const Color(0xff222426),
        textColor: Colors.white,
        borderColor: Colors.transparent,
      ),
    );
  }

  Widget _buildNextButton(
    RecipeTypeController controller,
    BuildContext context,
  ) {
    return Expanded(
      child: RecipeButton(
        text: 'Next',
        onPressed: controller.hasSelectedType
            ? () => _navigateToNextScreen(controller.selectedType, context)
            : null,
        backgroundColor: controller.hasSelectedType
            ? Colors.amber
            : Colors.grey,
        borderColor: controller.hasSelectedType ? Colors.amber : Colors.grey,
      ),
    );
  }

  void _navigateToNextScreen(String selectedType, BuildContext context) {
    if (selectedType == 'text') {
      context.push('/cook/recipe/text');
    } else if (selectedType == 'video') {
      context.push('/cook/recipe/video');
    }
  }
}
