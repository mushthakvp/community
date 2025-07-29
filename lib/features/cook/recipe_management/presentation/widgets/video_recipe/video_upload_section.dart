import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_constants.dart';

class VideoUploadSection extends StatelessWidget {
  final bool isUploading;
  final double uploadProgress;
  final String videoUrl;
  final VoidCallback onUpload;

  const VideoUploadSection({
    super.key,
    required this.isUploading,
    required this.uploadProgress,
    required this.videoUrl,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUploading ? null : onUpload,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppConstants.darkBlack,
        ),
        padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 50),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (isUploading) {
      return _buildUploadingState();
    } else if (videoUrl.isNotEmpty) {
      return _buildUploadedState();
    } else {
      return _buildInitialState();
    }
  }

  Widget _buildUploadingState() {
    return Column(
      children: [
        CircularProgressIndicator(value: uploadProgress, color: Colors.amber),
        const SizedBox(height: 10),
        Text(
          'Uploading Video: ${(uploadProgress * 100).toStringAsFixed(0)}%',
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
      ],
    );
  }

  Widget _buildInitialState() {
    return Column(
      children: [
        const Icon(Icons.videocam, size: 80, color: Colors.amber),
        const SizedBox(height: 10),
        const Text(
          'Upload video (3 min)',
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
