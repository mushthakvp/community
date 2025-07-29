import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../domain/entities/recipe.dart';
import '../controllers/media_upload_controller.dart';
import '../controllers/recipe_draft_controller.dart';
import '../controllers/recipe_submission_controller.dart';
import '../widgets/common/recipe_app_bar.dart';
import '../widgets/common/recipe_button.dart';
import '../widgets/common/recipe_text_field.dart';
import '../widgets/video_recipe/image_upload_section.dart';
import '../widgets/video_recipe/recipe_confirmation_dialog.dart';
import '../widgets/video_recipe/video_upload_section.dart';

class VideoRecipePage extends StatefulWidget {
  const VideoRecipePage({super.key});

  @override
  State<VideoRecipePage> createState() => _VideoRecipePageState();
}

class _VideoRecipePageState extends State<VideoRecipePage> {
  late RecipeDraftController draftController;
  late MediaUploadController mediaController;
  late RecipeSubmissionController submissionController;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController cookingTimeController;

  @override
  void initState() {
    super.initState();
    draftController = Get.find<RecipeDraftController>();
    mediaController = Get.find<MediaUploadController>();
    submissionController = Get.find<RecipeSubmissionController>();

    titleController = TextEditingController();
    descriptionController = TextEditingController();
    cookingTimeController = TextEditingController();

    _initializeControllers();
  }

  void _initializeControllers() {
    final draft = draftController.draft;
    titleController.text = draft.title ?? '';
    descriptionController.text = draft.description ?? '';
    cookingTimeController.text = draft.cookingTime ?? '';

    // Set recipe type if not already set
    if (draft.type != RecipeType.video) {
      draftController.updateType(RecipeType.video);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    cookingTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                title: 'Add video recipe',
                showBackButton: true,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleField(),
                      const SizedBox(height: 18),
                      _buildDescriptionField(),
                      const SizedBox(height: 18),
                      _buildCookingTimeField(),
                      const SizedBox(height: 18),
                      _buildVideoUploadSection(),
                      const SizedBox(height: 18),
                      _buildImageUploadSection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              _buildSubmitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return RecipeTextField(
      controller: titleController,
      hintText: 'Title',
      onChanged: (value) => draftController.updateTitle(value),
    );
  }

  Widget _buildDescriptionField() {
    return RecipeTextField(
      controller: descriptionController,
      hintText: 'Description',
      maxLines: 5,
      onChanged: (value) => draftController.updateDescription(value),
    );
  }

  Widget _buildCookingTimeField() {
    return RecipeTextField(
      controller: cookingTimeController,
      hintText: 'Cooking time',
      onChanged: (value) => draftController.updateCookingTime(value),
    );
  }

  Widget _buildVideoUploadSection() {
    return Obx(
      () => VideoUploadSection(
        isUploading: mediaController.isVideoUploading,
        uploadProgress: mediaController.videoUploadProgress,
        videoUrl: mediaController.uploadedVideoUrl,
        onUpload: () async {
          await mediaController.pickAndUploadVideo();
          if (mediaController.uploadedVideoUrl.isNotEmpty) {
            draftController.updateVideoUrl(mediaController.uploadedVideoUrl);
          }
        },
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Obx(
      () => ImageUploadSection(
        isUploading: mediaController.isImageUploading,
        uploadProgress: mediaController.imageUploadProgress,
        imageUrl: mediaController.uploadedImageUrl,
        onUpload: () async {
          await mediaController.pickAndUploadImage();
          if (mediaController.uploadedImageUrl.isNotEmpty) {
            draftController.updateDishImageUrl(
              mediaController.uploadedImageUrl,
            );
          }
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      final canSubmit = _canSubmitRecipe();
      final isSubmitting = submissionController.isSubmitting;

      return RecipeButton(
        text: isSubmitting ? 'Submitting...' : 'Submit',
        onPressed: canSubmit && !isSubmitting ? _onSubmitPressed : null,
        backgroundColor: canSubmit && !isSubmitting
            ? Colors.amber
            : Colors.grey,
        borderColor: canSubmit && !isSubmitting ? Colors.amber : Colors.grey,
        isLoading: isSubmitting,
      );
    });
  }

  bool _canSubmitRecipe() {
    return titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        cookingTimeController.text.trim().isNotEmpty &&
        mediaController.uploadedVideoUrl.isNotEmpty &&
        mediaController.uploadedImageUrl.isNotEmpty;
  }

  void _onSubmitPressed() {
    showDialog(
      context: context,
      builder: (context) => RecipeConfirmationDialog(
        onConfirm: _submitRecipe,
        onPreview: _showPreview,
      ),
    );
  }

  Future<void> _submitRecipe() async {
    Navigator.of(context).pop();
    const challengeId = 'your_challenge_id';
    final success = await submissionController.submitRecipe(
      challengeId: challengeId,
      draft: draftController.draft,
    );

    if (success) {
      context.go('/cook/my-challenges');
      draftController.reset();
      mediaController.reset();
    }
  }

  void _showPreview() {
    Navigator.of(context).pop();
  }
}
