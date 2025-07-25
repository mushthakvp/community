import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_video_recipe_controller.dart';

class VideoUploadSection extends StatelessWidget {
  final AddVideoRecipeController controller;

  const VideoUploadSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: controller.isVideoUploading
            ? null
            : controller.handleVideoUpload,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xff0F0F0F),
          ),
          padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 50),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (controller.isVideoUploading) {
      return _buildUploadingState();
    }

    if (controller.hasVideo) {
      return _buildUploadedState();
    }

    return _buildDefaultState();
  }

  Widget _buildUploadingState() {
    return Column(
      children: [
        CircularProgressIndicator(
          value: controller.videoUploadProgress,
          color: Colors.amber,
        ),
        const SizedBox(height: 10),
        Text(
          'Uploading Video: ${(controller.videoUploadProgress * 100).toStringAsFixed(0)}%',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildUploadedState() {
    return Column(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 50),
        const SizedBox(height: 10),
        const Text(
          'Video Uploaded',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: controller.handleVideoUpload,
          child: const Text(
            'Change Video',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultState() {
    return Column(
      children: [
        const Icon(Icons.videocam, size: 50, color: Colors.white54),
        const SizedBox(height: 10),
        const Text(
          'Upload video (3 min max)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'For consideration, please upload a three-minute video with audio showcasing your cooking skills',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
