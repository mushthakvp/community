import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_video_recipe_controller.dart';

class ImageUploadSection extends StatelessWidget {
  final AddVideoRecipeController controller;

  const ImageUploadSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.hasImage) {
        return _buildUploadedImageView();
      }

      if (controller.isImageUploading) {
        return _buildUploadingView();
      }

      return _buildUploadButton();
    });
  }

  Widget _buildUploadedImageView() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            controller.imageUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildErrorPlaceholder(),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: controller.isImageUploading
                ? null
                : controller.handleImageUpload,
            child: Container(
              padding: const EdgeInsets.only(top: 15, bottom: 30),
              child: Text(
                controller.isImageUploading ? 'Uploading...' : 'Change',
                style: TextStyle(
                  color: controller.isImageUploading
                      ? Colors.grey
                      : Colors.amber,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadingView() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xff0F0F0F),
      ),
      padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 50),
      child: Column(
        children: [
          CircularProgressIndicator(
            value: controller.imageUploadProgress,
            color: Colors.amber,
          ),
          const SizedBox(height: 10),
          Text(
            'Uploading Image: ${(controller.imageUploadProgress * 100).toStringAsFixed(0)}%',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return GestureDetector(
      onTap: controller.handleImageUpload,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xff0F0F0F),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Row(
          children: [
            Text(
              'Upload Dish picture',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            const Spacer(),
            const Icon(Icons.add_a_photo, color: Colors.white54, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[800],
      ),
      child: const Center(
        child: Icon(Icons.broken_image, color: Colors.grey, size: 60),
      ),
    );
  }
}
