import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class ImagePickerWidget extends StatelessWidget {
  final VoidCallback onTap;

  const ImagePickerWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.white.withOpacity(0.2),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                color: AppConstants.appPrimaryColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const CommonTextWidget(
              text: 'Select Image or PDF',
              color: AppConstants.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: 'Tap to choose from camera, gallery, or files',
              color: AppConstants.white.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
