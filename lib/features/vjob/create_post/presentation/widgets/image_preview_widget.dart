import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class ImagePreviewWidget extends StatelessWidget {
  final String imagePath;
  final String imageUrl;
  final bool isPdf;
  final VoidCallback onRemove;
  final VoidCallback onReplace;

  const ImagePreviewWidget({
    super.key,
    required this.imagePath,
    required this.imageUrl,
    required this.isPdf,
    required this.onRemove,
    required this.onReplace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // Preview Area
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppConstants.white.withOpacity(0.1)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildPreviewContent(),
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: 'Replace',
                  onPressed: onReplace,
                  backgroundColor: Colors.transparent,
                  borderColor: AppConstants.appPrimaryColor,
                  textColor: AppConstants.appPrimaryColor,
                  fontSize: 14,
                  height: 40,
                  prefix: const Icon(
                    Icons.swap_horiz,
                    color: AppConstants.appPrimaryColor,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: 'Remove',
                  onPressed: onRemove,
                  backgroundColor: Colors.transparent,
                  borderColor: Colors.red,
                  textColor: Colors.red,
                  fontSize: 14,
                  height: 40,
                  prefix: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent() {
    if (isPdf) {
      return Container(
        color: const Color(0xFF2A2A2A),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.picture_as_pdf, color: Colors.red, size: 48),
              SizedBox(height: 8),
              CommonTextWidget(
                text: 'PDF Document',
                color: AppConstants.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      );
    }

    // Image preview
    if (imagePath.isNotEmpty) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    } else if (imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: const Color(0xFF2A2A2A),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppConstants.appPrimaryColor,
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildErrorWidget(),
      );
    }

    return _buildErrorWidget();
  }

  Widget _buildErrorWidget() {
    return Container(
      color: const Color(0xFF2A2A2A),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, color: AppConstants.white, size: 48),
            SizedBox(height: 8),
            CommonTextWidget(
              text: 'Failed to load image',
              color: AppConstants.white,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}
