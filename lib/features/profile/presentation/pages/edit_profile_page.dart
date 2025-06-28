import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/inputs/text_field.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/profile_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final String _dialCode = '+91';

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    final provider = context.read<ProfileProvider>();
    final profile = provider.profile;

    if (profile != null) {
      _nameController.text = profile.name;
      _emailController.text = profile.email;
      _phoneController.text = profile.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Edit Profile'),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.updateProfileState == ProfileState.loading) {
            return const Center(
              child: LoadingWidget(message: 'Updating profile...'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildProfileImageSection(provider),
                  const SizedBox(height: 32),
                  _buildFormFields(),
                  const SizedBox(height: 32),
                  _buildSaveButton(provider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImageSection(ProfileProvider provider) {
    return Center(
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppConstants.white.withOpacity(0.1),
              border: Border.all(
                color: provider.selectedProfileImage != null
                    ? AppConstants.appPrimaryColor
                    : AppConstants.appPrimaryColor.withOpacity(0.3),
                width: provider.selectedProfileImage != null ? 3 : 2,
              ),
              boxShadow: provider.selectedProfileImage != null
                  ? [
                      BoxShadow(
                        color: AppConstants.appPrimaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : null,
            ),
            child: ClipOval(child: _buildProfileImageContent(provider)),
          ),

          // Upload progress overlay
          if (provider.isUploadingImage)
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
                          value: provider.uploadProgress,
                          strokeWidth: 3,
                          backgroundColor: AppConstants.white.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppConstants.appPrimaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CommonTextWidget(
                        text: '${(provider.uploadProgress * 100).toInt()}%',
                        fontSize: 12,
                        color: AppConstants.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: provider.isUploadingImage ? null : _pickImage,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: provider.isUploadingImage
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
                  boxShadow: provider.isUploadingImage
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
                  provider.isUploadingImage
                      ? Icons.hourglass_empty
                      : Icons.camera_alt,
                  size: 20,
                  color: AppConstants.black,
                ),
              ),
            ),
          ),

          // Remove Button (if image is selected and not uploading)
          if (provider.selectedProfileImage != null &&
              !provider.isUploadingImage)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => provider.clearSelectedProfileImage(),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),

          // Success indicator
          if (provider.uploadedImageUrl != null && !provider.isUploadingImage)
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
  }

  Widget _buildProfileImageContent(ProfileProvider provider) {
    if (provider.selectedProfileImage != null) {
      return Image.file(
        provider.selectedProfileImage!,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    } else if (provider.profile?.profileImage != null) {
      return Image.network(
        provider.profile!.profileImage,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.person,
            size: 50,
            color: AppConstants.white.withOpacity(0.7),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              color: AppConstants.appPrimaryColor,
            ),
          );
        },
      );
    } else {
      return Icon(
        Icons.person,
        size: 50,
        color: AppConstants.white.withOpacity(0.7),
      );
    }
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        CommonTextField(
          controller: _nameController,
          labelText: 'Full Name',
          validator: (value) => Validators.required(value, 'full name'),
        ),
        const SizedBox(height: 16),
        CommonTextField(
          controller: _emailController,
          labelText: 'Email',
          keyboardType: TextInputType.emailAddress,
          validator: Validators.email,
          enabled: false, // Email usually shouldn't be editable
        ),
        const SizedBox(height: 16),
        CommonTextField(
          controller: _phoneController,
          labelText: 'Phone Number',
          keyboardType: TextInputType.phone,
          validator: Validators.phone,
          enabled: false, // Phone usually shouldn't be editable in edit profile
        ),
      ],
    );
  }

  Widget _buildSaveButton(ProfileProvider provider) {
    return PrimaryButton(
      text: 'Save Changes',
      isLoading:
          provider.updateProfileState == ProfileState.loading ||
          provider.isUploadingImage,
      onPressed: _saveProfile,
      height: 56,
    );
  }

  Future<void> _pickImage() async {
    try {
      // Check permission first
      PermissionStatus permission = await Permission.photos.request();

      if (permission.isGranted) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
          maxWidth: 1024,
          maxHeight: 1024,
        );

        if (pickedFile != null) {
          context.read<ProfileProvider>().selectProfileImage(
            File(pickedFile.path),
          );
          context.showSuccessSnackBar('Profile picture selected successfully!');
        }
      } else if (permission.isDenied || permission.isPermanentlyDenied) {
        _showPermissionDialog();
      }
    } catch (e) {
      context.showErrorSnackBar('Failed to pick image: $e');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const CommonTextWidget(
          text: 'Photo Library Permission Required',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        content: CommonTextWidget(
          text:
              'Please grant photo library permission to select profile picture from your gallery.',
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

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<ProfileProvider>();

      provider
          .updateProfile(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            dialCode: _dialCode,
          )
          .then((_) {
            if (provider.updateProfileState == ProfileState.success) {
              context.showSuccessSnackBar('Profile updated successfully');
              Navigator.of(context).pop();
            } else if (provider.updateProfileState == ProfileState.error) {
              context.showErrorSnackBar(
                provider.updateProfileError ?? 'Failed to update profile',
              );
            }
          });
    }
  }
}
