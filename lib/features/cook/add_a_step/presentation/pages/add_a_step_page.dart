import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../controllers/add_step_controller.dart';
import '../widgets/image_upload_section.dart';
import '../widgets/step_form_section.dart';

class AddStepPage extends StatelessWidget {
  final int? editIndex;
  final Map<String, dynamic>? stepData;

  const AddStepPage({super.key, this.editIndex, this.stepData});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddStepController(), tag: _getControllerTag());

    return Scaffold(
      backgroundColor: AppConstants.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, controller),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildStepForm(controller),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildSaveButton(controller),
          ],
        ),
      ),
    );
  }

  String _getControllerTag() {
    return 'add_step_${editIndex ?? 'new'}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Widget _buildAppBar(BuildContext context, AddStepController controller) {
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
          Obx(
            () => Text(
              controller.stepTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepForm(AddStepController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff0F0F0F).withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(left: 21, right: 20, bottom: 20, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => _buildStepNumber(controller)),
          const SizedBox(height: 28),
          ImageUploadSection(controller: controller),
          const SizedBox(height: 20),
          StepFormSection(controller: controller),
        ],
      ),
    );
  }

  Widget _buildStepNumber(AddStepController controller) {
    return Text(
      controller.stepTitle,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }

  Widget _buildSaveButton(AddStepController controller) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.isPictureLoading || !controller.isFormValid
              ? null
              : controller.saveStep,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                controller.isPictureLoading || !controller.isFormValid
                ? Colors.grey
                : Colors.amber,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: controller.isPictureLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                )
              : const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }
}
