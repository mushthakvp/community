import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../controllers/preview_controller.dart';
import '../widgets/preview_content.dart';
import '../widgets/preview_loading_view.dart';

class PreviewPage extends StatefulWidget {
  final Map<String, dynamic> recipeData;
  final bool isFromPreview;

  const PreviewPage({
    super.key,
    required this.recipeData,
    this.isFromPreview = false,
  });

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late final PreviewController controller;
  late final String controllerTag;

  @override
  void initState() {
    super.initState();

    // Create unique controller tag
    controllerTag = 'preview_${DateTime.now().millisecondsSinceEpoch}';

    // Initialize controller
    controller = Get.put(
      PreviewController(submitRecipeUseCase: Get.find(tag: 'preview')),
      tag: controllerTag,
    );
  }

  @override
  void dispose() {
    // Clean up controller
    if (Get.isRegistered<PreviewController>(tag: controllerTag)) {
      Get.delete<PreviewController>(tag: controllerTag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: SafeArea(
        child: GetBuilder<PreviewController>(
          tag: controllerTag,
          builder: (controller) => Obx(() {
            if (controller.isLoading) {
              return const PreviewLoadingView();
            }

            return Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: PreviewContent(
                    recipeData: widget.recipeData,
                    controller: controller,
                  ),
                ),
                _buildSubmitButton(),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          if (!widget.isFromPreview)
            IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 24,
              ),
              padding: EdgeInsets.zero,
            ),
          const Spacer(),
          if (widget.isFromPreview)
            IconButton(
              onPressed: () => _navigateToEditDetails(),
              icon: const Icon(Icons.edit, color: Colors.amber, size: 24),
            ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: controller.isSubmitting ? null : () => _handleSubmit(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBackgroundColor: Colors.amber.withOpacity(0.5),
          ),
          child: controller.isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                )
              : const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    final recipeData = widget.recipeData;

    controller.submitRecipe(
      challengeId: recipeData['challengeId'] ?? '',
      title: recipeData['title'] ?? '',
      description: recipeData['description'] ?? '',
      recipeType: recipeData['recipeType'] ?? 'text',
      ingredients: recipeData['ingredients'] != null
          ? List<Map<String, dynamic>>.from(recipeData['ingredients'])
          : null,
      steps: recipeData['steps'] != null
          ? List<Map<String, dynamic>>.from(recipeData['steps'])
          : null,
      cookingTime: recipeData['cookingTime'],
      image: recipeData['image'],
      video: recipeData['video'],
    );
  }

  void _navigateToEditDetails() {
    context.push('/cook/edit-details', extra: widget.recipeData);
  }
}
