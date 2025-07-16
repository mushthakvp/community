import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';

class ImagePickerWidget extends StatelessWidget {
  final String? imageUrl;
  final bool isPdf;
  final bool isUploading;
  final VoidCallback onImagePick;
  final VoidCallback onImageRemove;

  const ImagePickerWidget({
    super.key,
    this.imageUrl,
    this.isPdf = false,
    this.isUploading = false,
    required this.onImagePick,
    required this.onImageRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUploading ? null : onImagePick,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.white.withOpacity(0.2),
            width: 2,
          ),
          color: AppConstants.black,
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (isUploading) {
      return _buildUploadingState();
    }

    if (imageUrl != null) {
      return _buildImagePreview();
    }

    return _buildEmptyState();
  }

  Widget _buildUploadingState() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingWidget(size: 40, showMessage: false),
        SizedBox(height: 12),
        CommonTextWidget(
          text: 'Uploading image...',
          fontSize: 14,
          color: AppConstants.white,
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: isPdf ? _buildPdfPreview() : _buildImageView(),
          ),
        ),
        Positioned(top: 8, right: 8, child: _buildRemoveButton()),
      ],
    );
  }

  Widget _buildPdfPreview() {
    return Container(
      color: AppConstants.white.withOpacity(0.05),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.picture_as_pdf, size: 64, color: Colors.red),
          SizedBox(height: 8),
          CommonTextWidget(
            text: 'PDF Document',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppConstants.white,
          ),
          SizedBox(height: 4),
          CommonTextWidget(
            text: 'Tap to change',
            fontSize: 12,
            color: AppConstants.white,
          ),
        ],
      ),
    );
  }

  Widget _buildImageView() {
    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorState();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingState();
      },
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: AppConstants.white.withOpacity(0.05),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          SizedBox(height: 8),
          CommonTextWidget(
            text: 'Failed to load image',
            fontSize: 14,
            color: AppConstants.white,
          ),
          SizedBox(height: 4),
          CommonTextWidget(
            text: 'Tap to retry',
            fontSize: 12,
            color: AppConstants.white,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: AppConstants.white.withOpacity(0.05),
      child: const Center(child: LoadingWidget(size: 30, showMessage: false)),
    );
  }

  Widget _buildRemoveButton() {
    return GestureDetector(
      onTap: onImageRemove,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: AppConstants.white, size: 18),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppConstants.white.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add_photo_alternate_outlined,
            size: 48,
            color: AppConstants.white,
          ),
        ),
        const SizedBox(height: 16),
        const CommonTextWidget(
          text: 'Select Image or PDF',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        const SizedBox(height: 4),
        CommonTextWidget(
          text: 'Tap to choose from gallery',
          fontSize: 12,
          color: AppConstants.white.withOpacity(0.7),
        ),
      ],
    );
  }
}
