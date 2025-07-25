import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../core/router/helper_router_cook.dart';
import '../controllers/add_recipe_controller.dart';
import '../widgets/method_selection_card.dart';
import '../widgets/recipe_illustration.dart';

class AddRecipePage extends StatelessWidget {
  const AddRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddRecipeController());

    return Scaffold(
      backgroundColor: AppConstants.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              _buildAppBar(context),
              const SizedBox(height: 16),
              const RecipeIllustration(),
              const SizedBox(height: 38),
              _buildMethodSelection(controller),
              const Spacer(),
              _buildActionButtons(context, controller),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
          onPressed: () => context.pop(),
          padding: EdgeInsets.zero,
        ),
        const SizedBox(width: 8),
        const Text(
          'Add recipe',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMethodSelection(AddRecipeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select method:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 18),
        Obx(
          () => Column(
            children: [
              MethodSelectionCard(
                title: 'Text Recipe',
                icon: Icons.text_fields,
                isSelected: controller.isMethodActive(RecipeMethod.text),
                onTap: () => controller.selectRecipeMethod(RecipeMethod.text),
              ),
              const SizedBox(height: 15),
              MethodSelectionCard(
                title: 'Video Recipe',
                icon: Icons.videocam,
                isSelected: controller.isMethodActive(RecipeMethod.video),
                onTap: () => controller.selectRecipeMethod(RecipeMethod.video),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    AddRecipeController controller,
  ) {
    return Obx(
      () => Row(
        children: [
          Expanded(child: _buildCancelButton(controller)),
          const SizedBox(width: 10),
          Expanded(child: _buildNextButton(context, controller)),
        ],
      ),
    );
  }

  Widget _buildCancelButton(AddRecipeController controller) {
    return ElevatedButton(
      onPressed: () => controller.resetSelection(),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff222426),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text(
        'Cancel',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildNextButton(
    BuildContext context,
    AddRecipeController controller,
  ) {
    final isEnabled = controller.isMethodSelected;

    return ElevatedButton(
      onPressed: isEnabled ? () => _handleNext(context, controller) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? Colors.amber : Colors.grey,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text(
        'Next',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _handleNext(BuildContext context, AddRecipeController controller) {
    switch (controller.selectedMethod) {
      case RecipeMethod.text:
        HelperRouterCook.navigateToTextRecipe(context);
        break;
      case RecipeMethod.video:
        HelperRouterCook.navigateToVideoRecipe(context);
        break;
      case RecipeMethod.none:
        break;
    }
  }
}
