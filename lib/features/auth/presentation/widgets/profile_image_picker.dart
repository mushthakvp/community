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
              // Profile Image Container
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
                child: authProvider.profileImage != null
                    ? ClipOval(
                        child: Image.file(
                          authProvider.profileImage!,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 60,
                        color: AppConstants.white.withOpacity(0.7),
                      ),
              ),

              // Camera Button
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showImagePickerDialog(context, authProvider),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppConstants.appPrimaryColor,
                          Color(0xFF00D4AA),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.appPrimaryColor.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: AppConstants.black,
                    ),
                  ),
                ),
              ),

              // Remove Button (if image is selected)
              if (authProvider.profileImage != null)
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
            ],
          ),
        );
      },
    );
  }

  void _showImagePickerDialog(BuildContext context, AuthProvider authProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppConstants.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              const CommonTextWidget(
                text: 'Select Profile Picture',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
                align: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Camera Option
              _buildImageOption(
                context: context,
                icon: Icons.camera_alt,
                title: 'Take Photo',
                subtitle: 'Use camera to take a new photo',
                onTap: () => _pickImageFromCamera(context, authProvider),
              ),

              const SizedBox(height: 16),

              // Gallery Option
              _buildImageOption(
                context: context,
                icon: Icons.photo_library,
                title: 'Choose from Gallery',
                subtitle: 'Select from your photo library',
                onTap: () => _pickImageFromGallery(context, authProvider),
              ),

              const SizedBox(height: 20),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: AppConstants.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                  child: const CommonTextWidget(
                    text: 'Cancel',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConstants.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppConstants.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppConstants.appPrimaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget(
                    text: title,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.white,
                  ),
                  const SizedBox(height: 4),
                  CommonTextWidget(
                    text: subtitle,
                    fontSize: 14,
                    color: AppConstants.white.withOpacity(0.7),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppConstants.white.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    Navigator.pop(context);

    // Request camera permission
    final cameraPermission = await Permission.camera.request();

    if (cameraPermission.isGranted) {
      try {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
          maxWidth: 1024,
          maxHeight: 1024,
        );

        if (image != null) {
          final File imageFile = File(image.path);
          authProvider.setProfileImage(imageFile);
          onImageSelected?.call(imageFile);
        }
      } catch (e) {
        _showErrorSnackBar(context, 'Failed to take photo: $e');
      }
    } else {
      _showPermissionDialog(context, 'Camera');
    }
  }

  Future<void> _pickImageFromGallery(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    Navigator.pop(context);

    // Request storage permission
    PermissionStatus permission;
    if (Platform.isAndroid) {
      if (await _getAndroidVersion() >= 33) {
        permission = await Permission.photos.request();
      } else {
        permission = await Permission.storage.request();
      }
    } else {
      permission = await Permission.photos.request();
    }

    if (permission.isGranted) {
      try {
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
        }
      } catch (e) {
        _showErrorSnackBar(context, 'Failed to pick image: $e');
      }
    } else {
      _showPermissionDialog(context, 'Storage');
    }
  }

  void _removeImage(AuthProvider authProvider) {
    authProvider.setProfileImage(null);
    onImageSelected?.call(null);
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
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
              'Please grant $permissionType permission to select profile picture.',
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
              text: 'Settings',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.appPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<int> _getAndroidVersion() async {
    // This is a simplified version. You might want to use a package like device_info_plus
    // for more accurate Android version detection
    return 30; // Default to Android 11+ for safety
  }
}
