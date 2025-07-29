import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../domain/entities/recipe.dart';
import '../controllers/recipe_draft_controller.dart';
import '../widgets/common/recipe_app_bar.dart';
import '../widgets/common/recipe_button.dart';
import '../widgets/recipe_steps/empty_steps_view.dart';
import '../widgets/recipe_steps/steps_list.dart';

class RecipeStepsPage extends StatelessWidget {
  const RecipeStepsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final draftController = Get.find<RecipeDraftController>();

    return Scaffold(
      backgroundColor: AppConstants.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const RecipeAppBar(
                title: 'Add recipe steps',
                showBackButton: true,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Obx(() => _buildContent(draftController, context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(RecipeDraftController controller, BuildContext context) {
    if (controller.draft.steps.isEmpty) {
      return EmptyStepsView(onAddStep: () => _navigateToAddStep(context));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: StepsList(
            steps: controller.draft.steps,
            onEditStep: (index) => _navigateToEditStep(context, index),
            onDeleteStep: (index) =>
                _showDeleteDialog(context, controller, index),
          ),
        ),
        const SizedBox(height: 8),
        _buildAddStepButton(context),
        const SizedBox(height: 20),
        _buildActionButtons(controller, context),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAddStepButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToAddStep(context),
      child: const Text(
        'Add a step',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.amber,
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    RecipeDraftController controller,
    BuildContext context,
  ) {
    return Obx(() {
      final hasSteps = controller.draft.steps.isNotEmpty;

      if (!hasSteps) return const SizedBox.shrink();

      return Row(
        children: [
          Expanded(
            child: RecipeButton(
              text: 'Cancel',
              onPressed: () => context.pop(),
              backgroundColor: const Color(0xff222426),
              textColor: Colors.white,
              borderColor: Colors.transparent,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RecipeButton(
              text: 'Next',
              onPressed: () => _navigateToSubmission(context),
              backgroundColor: Colors.amber,
              borderColor: Colors.amber,
            ),
          ),
        ],
      );
    });
  }

  void _navigateToAddStep(BuildContext context) {
    context.push('/cook/recipe/steps/add').then((result) {
      if (result == true) {
        // Refresh handled by Obx
      }
    });
  }

  void _navigateToEditStep(BuildContext context, int index) {
    context.push('/cook/recipe/steps/edit/$index').then((result) {
      if (result == true) {
        // Refresh handled by Obx
      }
    });
  }

  void _showDeleteDialog(
    BuildContext context,
    RecipeDraftController controller,
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
              controller.removeStep(index);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToSubmission(BuildContext context) {
    final controller = Get.find<RecipeDraftController>();
    if (controller.draft.type == RecipeType.text) {
      context.push('/cook/recipe/review');
    } else {
      context.pop();
    }
  }
}
