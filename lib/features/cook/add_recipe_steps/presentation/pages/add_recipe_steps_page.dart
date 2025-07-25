import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../core/router/helper_router_cook.dart';
import '../controllers/recipe_steps_controller.dart';
import '../widgets/empty_steps_view.dart';
import '../widgets/step_card.dart';
import '../widgets/steps_loading_view.dart';

class AddRecipeStepsPage extends StatelessWidget {
  const AddRecipeStepsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecipeStepsController());

    return Scaffold(
      backgroundColor: AppConstants.black,
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: controller.isLoading
                    ? const StepsLoadingView()
                    : _buildContent(context, controller),
              ),
              if (controller.hasSteps) _buildActionButtons(context, controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => context.pop(),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 8),
          const Text(
            'Add recipe steps',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, RecipeStepsController controller) {
    if (!controller.hasSteps) {
      return EmptyStepsView(onAddStep: () => _navigateToAddStep(context));
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: controller.recipeSteps.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final step = controller.recipeSteps[index];
              return StepCard(
                step: step,
                stepNumber: index + 1,
                onEdit: () => _navigateToEditStep(context, index, step),
                onDelete: () => _showDeleteDialog(context, controller, index),
              );
            },
          ),
        ),
        _buildAddStepButton(context),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAddStepButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () => _navigateToAddStep(context),
          child: const Text(
            'Add a step',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    RecipeStepsController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff222426),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _handleNext(context, controller),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddStep(BuildContext context) {
    HelperRouterCook.navigateToAddStep(context);
  }

  void _navigateToEditStep(BuildContext context, int index, dynamic step) {
    final stepData = {
      'title': step.title,
      'description': step.description,
      'image': step.imageUrl,
    };
    HelperRouterCook.navigateToAddStep(
      context,
      editIndex: index,
      stepData: stepData,
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    RecipeStepsController controller,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1E1E1E),
        title: const Text('Delete Step', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to delete this step?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              controller.deleteStep(index);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleNext(BuildContext context, RecipeStepsController controller) {
    if (controller.validateSteps()) {
      context.go('/cook/other-details');
    }
  }
}
