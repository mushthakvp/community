import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../providers/edit_ad_provider.dart';

class EditAdImagePickerWidget extends StatelessWidget {
  const EditAdImagePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditAdProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CommonTextWidget(
                  text: "Photos",
                  color: AppConstants.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.appPrimaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CommonTextWidget(
                    text: "${provider.totalImagesCount}/10",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.appPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.totalImagesCount + 1,
                itemBuilder: (context, index) {
                  if (index < provider.existingImages.length) {
                    // Existing network image
                    return _buildExistingImageCard(
                      context,
                      provider.existingImages[index],
                      index,
                      provider,
                    );
                  } else if (index < provider.totalImagesCount) {
                    // New local image
                    final newImageIndex =
                        index - provider.existingImages.length;
                    return _buildNewImageCard(
                      context,
                      provider.newImages[newImageIndex],
                      newImageIndex.toInt(),
                      provider,
                    );
                  } else {
                    // Add image button
                    return _buildAddImageButton(context, provider);
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: "First image will be used as cover photo",
              fontSize: 12,
              color: AppConstants.white.withOpacity(0.6),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExistingImageCard(
    BuildContext context,
    String imageUrl,
    int index,
    EditAdProvider provider,
  ) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.appPrimaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: 116,
              height: 116,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 116,
                  height: 116,
                  color: AppConstants.white.withOpacity(0.1),
                  child: Icon(
                    Icons.image_not_supported,
                    color: AppConstants.white.withOpacity(0.5),
                    size: 32,
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => provider.removeExistingImage(index),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.close,
                  color: AppConstants.white,
                  size: 16,
                ),
              ),
            ),
          ),
          if (index == 0)
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: AppConstants.appPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const CommonTextWidget(
                  text: "Cover",
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.black,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNewImageCard(
    BuildContext context,
    File imageFile,
    int index,
    EditAdProvider provider,
  ) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.5), width: 2),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              imageFile,
              width: 116,
              height: 116,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => provider.removeNewImage(index),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.close,
                  color: AppConstants.white,
                  size: 16,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const CommonTextWidget(
                text: "New",
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton(BuildContext context, EditAdProvider provider) {
    return GestureDetector(
      onTap: provider.canAddMoreImages ? provider.addImages : null,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFF262626),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: provider.canAddMoreImages
                ? AppConstants.appPrimaryColor.withOpacity(0.5)
                : AppConstants.white.withOpacity(0.2),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: provider.canAddMoreImages
                  ? AppConstants.appPrimaryColor
                  : AppConstants.white.withOpacity(0.4),
              size: 32,
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: provider.canAddMoreImages ? "Add Photos" : "Limit Reached",
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: provider.canAddMoreImages
                  ? AppConstants.appPrimaryColor
                  : AppConstants.white.withOpacity(0.4),
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
