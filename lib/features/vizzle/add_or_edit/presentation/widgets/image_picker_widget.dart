import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/card_widget.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../providers/add_edit_provider.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddEditProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: "Add Photos",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.selectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index < provider.selectedImages.length) {
                    return _buildImageTile(
                      context,
                      provider.selectedImages[index],
                      index,
                      provider,
                    );
                  } else {
                    return _buildAddImageTile(context, provider);
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text:
                  'Photos: ${provider.selectedImages.length}/10 • Choose main photo first',
              color: AppConstants.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ],
        );
      },
    );
  }

  Widget _buildImageTile(
    BuildContext context,
    File image,
    int index,
    AddEditProvider provider,
  ) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          CommonCard(
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                AppConstants.defaultBorderRadius,
              ),
              child: Image.file(
                image,
                width: 100,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => provider.removeImage(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
          if (index == 0)
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppConstants.appPrimaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const CommonTextWidget(
                  text: "Main",
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

  Widget _buildAddImageTile(BuildContext context, AddEditProvider provider) {
    return GestureDetector(
      onTap: () => _showImageSourceDialog(context, provider),
      child: Container(
        width: 100,
        height: 120,
        margin: const EdgeInsets.only(right: 12),
        child: CommonCard(
          backgroundColor: AppConstants.surfaceVariant,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 32,
                color: AppConstants.white.withOpacity(0.6),
              ),
              const SizedBox(height: 8),
              CommonTextWidget(
                text: "Add Photo",
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppConstants.white.withOpacity(0.6),
                align: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context, AddEditProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.surfaceVariant,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CommonTextWidget(
              text: "Select Image Source",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildSourceOption(
                    context,
                    icon: Icons.camera_alt,
                    title: "Camera",
                    onTap: () {
                      Navigator.pop(context);
                      provider.pickImages(fromGallery: false);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSourceOption(
                    context,
                    icon: Icons.photo_library,
                    title: "Gallery",
                    onTap: () {
                      Navigator.pop(context);
                      provider.pickImages(fromGallery: true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CommonCard(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppConstants.appPrimaryColor),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: title,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
