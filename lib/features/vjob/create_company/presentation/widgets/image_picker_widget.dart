import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class ImagePickerWidget extends StatelessWidget {
  final String? imageUrl;
  final bool isUploading;
  final double uploadProgress;
  final VoidCallback onTap;

  const ImagePickerWidget({
    super.key,
    this.imageUrl,
    this.isUploading = false,
    this.uploadProgress = 0.0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUploading ? null : onTap,
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          color: const Color(0xff161616),
          borderRadius: BorderRadius.circular(60),
          border: Border.all(
            color: AppConstants.white.withOpacity(0.1),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            // Main content
            Center(child: _buildContent()),
            // Upload progress overlay
            if (isUploading) _buildProgressOverlay(),
            // Edit icon
            if (!isUploading) _buildEditIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(58),
        child: Image.network(
          imageUrl!,
          width: 116,
          height: 116,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildPlaceholder();
          },
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.business,
          size: 32,
          color: AppConstants.white.withOpacity(0.5),
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: 'Add Logo',
          fontSize: 12,
          color: AppConstants.white.withOpacity(0.7),
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildProgressOverlay() {
    return Container(
      width: 116,
      height: 116,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(58),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: uploadProgress,
              color: AppConstants.appPrimaryColor,
              strokeWidth: 3,
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: '${(uploadProgress * 100).toInt()}%',
              fontSize: 12,
              color: AppConstants.white,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditIcon() {
    return Positioned(
      bottom: 8,
      right: 8,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppConstants.appPrimaryColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppConstants.black, width: 2),
        ),
        child: const Icon(
          Icons.camera_alt,
          size: 16,
          color: AppConstants.black,
        ),
      ),
    );
  }
}
