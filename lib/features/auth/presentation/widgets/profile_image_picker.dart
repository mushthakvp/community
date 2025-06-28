// lib/features/auth/presentation/widgets/profile_image_picker.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/auth_provider.dart';

class ProfileImagePicker extends StatelessWidget {
  final Function(File?)? onImageSelected;

  const ProfileImagePicker({super.key, this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Center(
          child: Stack(
            children: [
              // Main profile image container
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConstants.white.withOpacity(0.1),
                  border: Border.all(
                    color: authProvider.profileImage != null
                        ? AppConstants.appPrimaryColor
                        : AppConstants.appPrimaryColor.withOpacity(0.3),
                    width: authProvider.profileImage != null ? 3 : 2,
                  ),
                  boxShadow: authProvider.profileImage != null
                      ? [
                          BoxShadow(
                            color: AppConstants.appPrimaryColor.withOpacity(
                              0.3,
                            ),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : null,
                ),
                child: ClipOval(
                  child: authProvider.profileImage != null
                      ? Image.file(
                          authProvider.profileImage!,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        )
                      : Icon(
                          Icons.person,
                          size: 60,
                          color: AppConstants.white.withOpacity(0.7),
                        ),
                ),
              ),

              // Upload progress overlay
              if (authProvider.isUploadingImage)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppConstants.black.withOpacity(0.7),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              value: authProvider.uploadProgress,
                              strokeWidth: 3,
                              backgroundColor: AppConstants.white.withOpacity(
                                0.3,
                              ),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppConstants.appPrimaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CommonTextWidget(
                            text:
                                '${(authProvider.uploadProgress * 100).toInt()}%',
                            fontSize: 12,
                            color: AppConstants.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Camera/Add Button
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: authProvider.isUploadingImage
                      ? null
                      : () => _pickImageFromGallery(context, authProvider),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: authProvider.isUploadingImage
                          ? LinearGradient(
                              colors: [
                                AppConstants.appPrimaryColor.withOpacity(0.5),
                                const Color(0xFF00D4AA).withOpacity(0.5),
                              ],
                            )
                          : const LinearGradient(
                              colors: [
                                AppConstants.appPrimaryColor,
                                Color(0xFF00D4AA),
                              ],
                            ),
                      shape: BoxShape.circle,
                      boxShadow: authProvider.isUploadingImage
                          ? null
                          : [
                              BoxShadow(
                                color: AppConstants.appPrimaryColor.withOpacity(
                                  0.4,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                    ),
                    child: Icon(
                      authProvider.isUploadingImage
                          ? Icons.hourglass_empty
                          : (authProvider.profileImage != null
                                ? Icons.edit
                                : Icons.add_a_photo),
                      size: 20,
                      color: AppConstants.black,
                    ),
                  ),
                ),
              ),

              // Remove Button (if image is selected and not uploading)
              if (authProvider.profileImage != null &&
                  !authProvider.isUploadingImage)
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _removeImage(authProvider),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              // Success indicator
              if (authProvider.uploadedImageUrl != null &&
                  !authProvider.isUploadingImage)
                const Positioned(
                  top: 0,
                  left: 0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check, size: 16, color: Colors.white),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    try {
      // Check permission first
      PermissionStatus permission = await Permission.photos.request();

      if (permission.isGranted) {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
          maxWidth: 1024,
          maxHeight: 1024,
        );

        if (image != null) {
          final File imageFile = File(image.path);
          authProvider.setProfileImage(imageFile);
          onImageSelected?.call(imageFile);

          // Show success message
          _showSuccessSnackBar(
            context,
            'Profile picture selected successfully!',
          );
        }
      } else if (permission.isDenied) {
        _showPermissionDialog(context, 'Photo Library');
      } else if (permission.isPermanentlyDenied) {
        _showPermissionDialog(context, 'Photo Library');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to pick image: $e');
    }
  }

  void _removeImage(AuthProvider authProvider) {
    authProvider.setProfileImage(null);
    onImageSelected?.call(null);
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showPermissionDialog(BuildContext context, String permissionType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: CommonTextWidget(
          text: '$permissionType Permission Required',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        content: CommonTextWidget(
          text:
              'Please grant $permissionType permission to select profile picture from your gallery.',
          fontSize: 14,
          color: AppConstants.white.withOpacity(0.8),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CommonTextWidget(
              text: 'Cancel',
              fontSize: 14,
              color: AppConstants.white.withOpacity(0.6),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const CommonTextWidget(
              text: 'Open Settings',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.appPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
