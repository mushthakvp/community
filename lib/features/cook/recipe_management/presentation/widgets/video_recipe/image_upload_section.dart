import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_constants.dart';

class ImageUploadSection extends StatelessWidget {
  final bool isUploading;
  final double uploadProgress;
  final String imageUrl;
  final VoidCallback onUpload;

  const ImageUploadSection({
    super.key,
    required this.isUploading,
    required this.uploadProgress,
    required this.imageUrl,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isNotEmpty) {
      return _buildUploadedImageView();
    } else if (isUploading) {
      return _buildUploadingView();
    } else {
      return _buildUploadButton();
    }
  }

  Widget _buildUploadedImageView() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[800],
                child: const Icon(Icons.error, color: Colors.red, size: 50),
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: onUpload,
            child: const Text(
              'Change',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
        color: AppConstants.darkBlack,
      ),
      padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 50),
      child: Column(
        children: [
          CircularProgressIndicator(value: uploadProgress, color: Colors.amber),
          const SizedBox(height: 10),
          Text(
            'Uploading Image: ${(uploadProgress * 100).toStringAsFixed(0)}%',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return GestureDetector(
      onTap: onUpload,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppConstants.darkBlack,
        ),
        child: const Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'Upload Dish picture',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Icon(Icons.camera_alt, color: Colors.amber, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
