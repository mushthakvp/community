import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../controllers/add_video_recipe_controller.dart';
import '../widgets/form_section.dart';
import '../widgets/image_upload_section.dart';
import '../widgets/submit_confirmation_dialog.dart';
import '../widgets/video_upload_section.dart';

class AddVideoRecipePage extends StatelessWidget {
  const AddVideoRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddVideoRecipeController());

    return Scaffold(
      backgroundColor: AppConstants.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    FormSection(controller: controller),
                    const SizedBox(height: 18),
                    VideoUploadSection(controller: controller),
                    const SizedBox(height: 18),
                    ImageUploadSection(controller: controller),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildSubmitButton(context, controller),
          ],
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
            'Add video recipe',
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

  Widget _buildSubmitButton(
    BuildContext context,
    AddVideoRecipeController controller,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.isFormValid
              ? () => _showSubmitDialog(context, controller)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.isFormValid
                ? Colors.amber
                : Colors.grey,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  void _showSubmitDialog(
    BuildContext context,
    AddVideoRecipeController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => SubmitConfirmationDialog(
        onConfirm: controller.submitRecipe,
        onPreview: () {
          // Navigate to preview page
          Navigator.of(context).pop();
          context.push(
            '/cook/preview',
            extra: {
              'title': controller.titleController.text,
              'description': controller.descriptionController.text,
              'cookingTime': controller.cookingTimeController.text,
              'videoUrl': controller.videoUrl,
              'imageUrl': controller.imageUrl,
              'type': 'video',
            },
          );
        },
      ),
    );
  }
}
