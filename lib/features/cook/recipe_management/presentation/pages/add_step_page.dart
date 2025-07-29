import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../domain/entities/recipe_step.dart';
import '../controllers/media_upload_controller.dart';
import '../controllers/recipe_draft_controller.dart';
import '../widgets/add_step/step_image_section.dart';
import '../widgets/common/recipe_app_bar.dart';
import '../widgets/common/recipe_button.dart';
import '../widgets/common/recipe_text_field.dart';

class AddStepPage extends StatefulWidget {
  final int? editIndex;

  const AddStepPage({super.key, this.editIndex});

  @override
  State<AddStepPage> createState() => _AddStepPageState();
}

class _AddStepPageState extends State<AddStepPage> {
  late RecipeDraftController draftController;
  late MediaUploadController mediaController;
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  String? existingImageUrl;
  bool get isEditing => widget.editIndex != null;

  @override
  void initState() {
    super.initState();
    draftController = Get.find<RecipeDraftController>();
    mediaController = Get.find<MediaUploadController>();
    titleController = TextEditingController();
    descriptionController = TextEditingController();

    _initializeForEditing();
  }

  void _initializeForEditing() {
    if (isEditing) {
      final step = draftController.draft.steps[widget.editIndex!];
      titleController.text = step.title;
      descriptionController.text = step.description;
      existingImageUrl = step.imageUrl;

      // Reset media controller for this step
      mediaController.reset();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
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
              _buildHeader(),
              const SizedBox(height: 16),
              Expanded(child: SingleChildScrollView(child: _buildStepForm())),
              _buildSaveButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return RecipeAppBar(
      title: isEditing ? 'Edit Step ${widget.editIndex! + 1}' : 'Add a Step',
      showBackButton: true,
    );
  }

  Widget _buildStepForm() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppConstants.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(left: 21, right: 20, bottom: 20, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle(),
          const SizedBox(height: 28),
          _buildImageUploadSection(),
          const SizedBox(height: 10),
          _buildTextFieldLabel('Title'),
          const SizedBox(height: 8),
          _buildTitleTextField(),
          const SizedBox(height: 10),
          _buildTextFieldLabel('Description'),
          const SizedBox(height: 8),
          _buildDescriptionTextField(),
        ],
      ),
    );
  }

  Widget _buildStepTitle() {
    final stepNumber = isEditing
        ? widget.editIndex! + 1
        : draftController.draft.steps.length + 1;

    return Text(
      isEditing ? 'Edit Step $stepNumber' : 'Step $stepNumber',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Obx(
      () => StepImageSection(
        isUploading: mediaController.isImageUploading,
        uploadProgress: mediaController.imageUploadProgress,
        uploadedImageUrl: mediaController.uploadedImageUrl,
        existingImageUrl: existingImageUrl,
        onUpload: () async {
          await mediaController.pickAndUploadImage();
        },
      ),
    );
  }

  Widget _buildTextFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTitleTextField() {
    return RecipeTextField(
      controller: titleController,
      hintText: 'Enter title',
      backgroundColor: Colors.transparent,
      borderColor: const Color(0xff363535),
    );
  }

  Widget _buildDescriptionTextField() {
    return RecipeTextField(
      controller: descriptionController,
      hintText: 'Description',
      maxLines: 4,
      backgroundColor: Colors.transparent,
      borderColor: const Color(0xff363535),
    );
  }

  Widget _buildSaveButton() {
    return Obx(
      () => RecipeButton(
        text: 'Save',
        onPressed: mediaController.isImageUploading ? null : _saveStep,
        backgroundColor: mediaController.isImageUploading
            ? Colors.grey
            : Colors.amber,
        borderColor: mediaController.isImageUploading
            ? Colors.grey
            : Colors.amber,
        isLoading: mediaController.isImageUploading,
      ),
    );
  }

  void _saveStep() {
    if (!_validateForm()) return;

    // Determine which image URL to use
    String imageToUse = '';
    if (mediaController.uploadedImageUrl.isNotEmpty) {
      // User selected a new image
      imageToUse = mediaController.uploadedImageUrl;
    } else if (existingImageUrl != null && existingImageUrl!.isNotEmpty) {
      // Keep existing image
      imageToUse = existingImageUrl!;
    }

    final step = RecipeStep(
      id: isEditing
          ? draftController.draft.steps[widget.editIndex!].id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      imageUrl: imageToUse.isNotEmpty ? imageToUse : null,
      order: isEditing ? widget.editIndex! : draftController.draft.steps.length,
    );

    if (isEditing) {
      draftController.updateStep(widget.editIndex!, step);
    } else {
      draftController.addStep(step);
    }

    // Go back and signal that we've updated
    context.pop(true);
  }

  bool _validateForm() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter step title',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter step description',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (mediaController.isImageUploading) {
      Get.snackbar(
        'Error',
        'Please wait for image upload to complete',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }
}
