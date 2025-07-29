import 'package:flutter/material.dart';

class StepImageSection extends StatelessWidget {
  final bool isUploading;
  final double uploadProgress;
  final String uploadedImageUrl;
  final String? existingImageUrl;
  final VoidCallback onUpload;

  const StepImageSection({
    super.key,
    required this.isUploading,
    required this.uploadProgress,
    required this.uploadedImageUrl,
    this.existingImageUrl,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onUpload,
        child: Stack(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xff292929),
              ),
              child: Center(child: _buildImageWidget()),
            ),
            // Upload progress indicator
            if (isUploading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black54,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      value: uploadProgress,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.amber,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    // Priority: uploaded image > existing image > default icon
    if (uploadedImageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          uploadedImageUrl,
          fit: BoxFit.cover,
          height: 80,
          width: 80,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultIcon();
          },
        ),
      );
    } else if (existingImageUrl != null && existingImageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          existingImageUrl!,
          fit: BoxFit.cover,
          height: 80,
          width: 80,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultIcon();
          },
        ),
      );
    } else {
      return _buildDefaultIcon();
    }
  }

  Widget _buildDefaultIcon() {
    return const Icon(Icons.camera_alt, color: Colors.amber, size: 30);
  }
}
