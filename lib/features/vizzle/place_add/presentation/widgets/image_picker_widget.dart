import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/spacer_widget.dart';
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
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: provider.selectedImages.length + 1,
                separatorBuilder: (context, index) => AppSpacing.horizontalSM,
                itemBuilder: (context, index) {
                  if (index < provider.selectedImages.length) {
                    return _buildImageItem(
                      context,
                      XFile(provider.selectedImages[index].path),
                      index,
                      provider,
                    );
                  } else {
                    return _buildAddImageButton(context, provider);
                  }
                },
              ),
            ),
            AppSpacing.verticalSM,
            CommonTextWidget(
              text:
                  'Photos: ${provider.selectedImages.length}/10 '
                  'Choose main photo first',
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
    XFile image,
    int index,
    PlaceAddProvider provider,
  ) {
    return Container(
      width: 95,
      height: 160,
      decoration: BoxDecoration(
        color: AppConstants.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Container(
            width: 84,
            height: 120,
            margin: const EdgeInsets.all(5.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: FileImage(File(image.path)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: -8,
            top: -8,
            child: IconButton(
              onPressed: () => provider.removeImage(index),
              icon: const Icon(
                Icons.close,
                color: AppConstants.black,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton(BuildContext context, PlaceAddProvider provider) {
    return GestureDetector(
      onTap: () => _showImageSourceDialog(context, provider),
      child: Container(
        width: 100,
        height: 160,
        decoration: BoxDecoration(
          color: AppConstants.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 30,
              color: AppConstants.appPrimaryColor,
            ),
            AppSpacing.verticalSM,
            CommonTextWidget(
              text: 'Add Photos',
              fontSize: 14,
              fontWeight: FontWeight.w400,
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
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CommonTextWidget(
              text: 'Select Image Source',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            AppSpacing.verticalXL,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  context,
                  'Camera',
                  Icons.camera_alt,
                  () async {
                    Navigator.pop(context);
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (image != null) {
                      provider.addImage(true);
                    }
                  },
                ),
                _buildSourceOption(
                  context,
                  'Gallery',
                  Icons.photo_library,
                  () async {
                    Navigator.pop(context);
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      provider.addImage(true);
                    }
                  },
                ),
              ],
            ),
            AppSpacing.verticalXL,
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
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppConstants.appPrimaryColor, width: 1),
            ),
            child: Icon(icon, size: 40, color: AppConstants.appPrimaryColor),
          ),
          AppSpacing.verticalSM,
          CommonTextWidget(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppConstants.appPrimaryColor,
          ),
        ],
      ),
    );
  }
}
