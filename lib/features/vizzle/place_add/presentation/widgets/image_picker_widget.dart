import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../providers/place_add_provider.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaceAddProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: 'Photos *',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: provider.selectedImages.length + 1,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  if (index < provider.selectedImages.length) {
                    return _buildImageItem(
                      context,
                      provider.selectedImages[index],
                      index,
                      provider,
                    );
                  } else {
                    return _buildAddImageButton(context, provider);
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text:
                  'Photos: ${provider.selectedImages.length}/10 • Choose main photo first',
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: AppConstants.white.withOpacity(0.6),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImageItem(
    BuildContext context,
    File image,
    int index,
    PlaceAddProvider provider,
  ) {
    return Container(
      width: 100,
      height: 120,
      decoration: BoxDecoration(
        color: AppConstants.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: index == 0
              ? AppConstants.appPrimaryColor
              : AppConstants.white.withOpacity(0.2),
          width: index == 0 ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              image,
              width: 100,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),

          // Main photo indicator
          if (index == 0)
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppConstants.appPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const CommonTextWidget(
                  text: 'Main',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.black,
                ),
              ),
            ),

          // Remove button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => provider.removeImage(index),
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton(BuildContext context, PlaceAddProvider provider) {
    final canAddMore = provider.selectedImages.length < 10;

    return GestureDetector(
      onTap: canAddMore
          ? () => _showImageSourceDialog(context, provider)
          : null,
      child: Container(
        width: 100,
        height: 120,
        decoration: BoxDecoration(
          color: AppConstants.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.white.withOpacity(0.3),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 32,
              color: canAddMore
                  ? AppConstants.appPrimaryColor
                  : AppConstants.white.withOpacity(0.3),
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: canAddMore ? 'Add Photo' : 'Max 10',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: canAddMore
                  ? AppConstants.white
                  : AppConstants.white.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context, PlaceAddProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.surfaceVariant,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CommonTextWidget(
              text: 'Select Image Source',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  context,
                  'Camera',
                  Icons.camera_alt,
                  () async {
                    Navigator.pop(context);
                    await provider.addImage(false); // false = camera
                  },
                ),
                _buildSourceOption(
                  context,
                  'Gallery',
                  Icons.photo_library,
                  () async {
                    Navigator.pop(context);
                    await provider.addImage(true); // true = gallery
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppConstants.appPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppConstants.appPrimaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, size: 40, color: AppConstants.appPrimaryColor),
          ),
          const SizedBox(height: 12),
          CommonTextWidget(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppConstants.appPrimaryColor,
          ),
        ],
      ),
    );
  }
}
