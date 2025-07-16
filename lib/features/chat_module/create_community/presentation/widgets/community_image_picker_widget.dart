import 'dart:io';

import 'package:flutter/material.dart';

class CommunityImagePickerWidget extends StatelessWidget {
  final File? selectedImage;
  final String? uploadedImageUrl;
  final bool isUploading;
  final VoidCallback onImageSelect;
  final VoidCallback onImageRemove;

  const CommunityImagePickerWidget({
    super.key,
    this.selectedImage,
    this.uploadedImageUrl,
    required this.isUploading,
    required this.onImageSelect,
    required this.onImageRemove,
  });

  bool get hasImage => selectedImage != null || uploadedImageUrl != null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          _buildImageContainer(context),
          const SizedBox(height: 16),
          _buildImageActions(context),
        ],
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context) {
    return GestureDetector(
      onTap: onImageSelect,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: hasImage
              ? Colors.transparent
              : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(60),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            // Image or placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(58),
              child: _buildImageContent(context),
            ),

            // Upload overlay
            if (isUploading)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(58),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Uploading...',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Edit icon
            if (!isUploading)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    hasImage ? Icons.edit : Icons.camera_alt,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContent(BuildContext context) {
    if (selectedImage != null) {
      return Image.file(
        selectedImage!,
        width: 116,
        height: 116,
        fit: BoxFit.cover,
      );
    } else if (uploadedImageUrl != null) {
      return Image.network(
        uploadedImageUrl!,
        width: 116,
        height: 116,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(context);
        },
      );
    } else {
      return _buildPlaceholder(context);
    }
  }

  Widget _buildPlaceholder(BuildContext context) {
    return SizedBox(
      width: 116,
      height: 116,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate,
            size: 32,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(height: 8),
          Text(
            'Add Photo',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: isUploading ? null : onImageSelect,
          icon: Icon(
            hasImage ? Icons.edit : Icons.add_photo_alternate,
            size: 18,
          ),
          label: Text(hasImage ? 'Change Photo' : 'Add Photo'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        if (hasImage && !isUploading) ...[
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: onImageRemove,
            icon: const Icon(Icons.delete, size: 18),
            label: const Text('Remove'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              side: BorderSide(
                color: Theme.of(context).colorScheme.error.withOpacity(0.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
