import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_step_controller.dart';

class ImageUploadSection extends StatelessWidget {
  final AddStepController controller;

  const ImageUploadSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Obx(
        () => GestureDetector(
          onTap: controller.isPictureLoading
              ? null
              : controller.pickAndUploadImage,
          child: Stack(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xff292929),
                ),
                child: Center(child: _buildImageContent()),
              ),
              if (controller.isPictureLoading) _buildLoadingOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    final displayImage = controller.currentDisplayImage;

    if (displayImage.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          displayImage,
          fit: BoxFit.cover,
          height: 80,
          width: 80,
          errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(),
        ),
      );
    }

    return _buildDefaultIcon();
  }

  Widget _buildDefaultIcon() {
    return const Icon(Icons.add_a_photo, color: Colors.white54, size: 30);
  }

  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black54,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                value: controller.uploadProgress,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                strokeWidth: 2,
              ),
              const SizedBox(height: 4),
              Text(
                '${(controller.uploadProgress * 100).toInt()}%',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
