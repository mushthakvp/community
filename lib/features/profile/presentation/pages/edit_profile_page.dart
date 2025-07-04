import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/inputs/text_field.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../../../home/presentation/providers/home_provider.dart';
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
    debugPrint('EditProfile: initState called');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeForm();
    });
  }

  void _initializeForm() {
    // Get user data from HomeProvider instead of ProfileProvider
    final homeProvider = context.read<HomeProvider>();
    final userDetails = homeProvider.userDetails;

    debugPrint(
      'EditProfile: Initializing form with home user details: $userDetails',
    );

    if (userDetails != null && mounted) {
      setState(() {
        _nameController.text = userDetails.name;
        _emailController.text = userDetails.email;
        _phoneController.text = userDetails.phone;
      });
      debugPrint(
        'EditProfile: Form initialized - Name: ${userDetails.name}, Email: ${userDetails.email}, Phone: ${userDetails.phone}',
      );
    } else {
      debugPrint(
        'EditProfile: Cannot initialize form - userDetails is null or widget not mounted',
      );
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
    debugPrint('EditProfile: Building widget');

    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Edit Profile'),
      body: Consumer2<HomeProvider, ProfileProvider>(
        builder: (context, homeProvider, profileProvider, child) {
          debugPrint(
            'EditProfile: Consumer builder - Home State: ${homeProvider.status}, Home UserDetails: ${homeProvider.userDetails != null}',
          );

          // Show loading if updating profile
          if (profileProvider.updateProfileState == ProfileState.loading) {
            return const Center(
              child: LoadingWidget(message: 'Updating profile...'),
            );
          }

          // Show loading if home data is loading
          if (homeProvider.isLoading) {
            return const Center(
              child: LoadingWidget(message: 'Loading profile...'),
            );
          }

          // Show error state if home data failed to load
          if (homeProvider.hasError) {
            debugPrint(
              'EditProfile: Showing error state: ${homeProvider.errorMessage}',
            );
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.withOpacity(0.7),
                  ),
                  const SizedBox(height: 16),
                  const CommonTextWidget(
                    text: 'Failed to load profile',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.white,
                  ),
                  const SizedBox(height: 8),
                  CommonTextWidget(
                    text: homeProvider.errorMessage ?? 'Unknown error occurred',
                    fontSize: 14,
                    color: AppConstants.white.withOpacity(0.7),
                    align: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () =>
                        homeProvider.loadUserDetails(forceRefresh: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.appPrimaryColor,
                      foregroundColor: AppConstants.black,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // If userDetails is null but no error, show loading
          if (homeProvider.userDetails == null) {
            debugPrint('EditProfile: UserDetails is null, showing loading');
            return const Center(
              child: LoadingWidget(message: 'Loading profile...'),
            );
          }

          debugPrint('EditProfile: Showing main content');
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildProfileImageSection(homeProvider, profileProvider),
                  const SizedBox(height: 32),
                  _buildFormFields(homeProvider),
                  const SizedBox(height: 32),
                  _buildSaveButton(profileProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImageSection(
    HomeProvider homeProvider,
    ProfileProvider profileProvider,
  ) {
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
                color: profileProvider.selectedProfileImage != null
                    ? AppConstants.appPrimaryColor
                    : AppConstants.appPrimaryColor.withOpacity(0.3),
                width: profileProvider.selectedProfileImage != null ? 3 : 2,
              ),
              boxShadow: profileProvider.selectedProfileImage != null
                  ? [
                      BoxShadow(
                        color: AppConstants.appPrimaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : null,
            ),
            child: ClipOval(
              child: _buildProfileImageContent(homeProvider, profileProvider),
            ),
          ),

          // Upload progress overlay
          if (profileProvider.isUploadingImage)
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
                          value: profileProvider.uploadProgress,
                          strokeWidth: 3,
                          backgroundColor: AppConstants.white.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppConstants.appPrimaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CommonTextWidget(
                        text:
                            '${(profileProvider.uploadProgress * 100).toInt()}%',
                        fontSize: 12,
                        color: AppConstants.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Camera button
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: profileProvider.isUploadingImage ? null : _pickImage,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: profileProvider.isUploadingImage
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
                  boxShadow: profileProvider.isUploadingImage
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
                  profileProvider.isUploadingImage
                      ? Icons.hourglass_empty
                      : Icons.camera_alt,
                  size: 20,
                  color: AppConstants.black,
                ),
              ),
            ),
          ),

          // Remove Button (if image is selected and not uploading)
          if (profileProvider.selectedProfileImage != null &&
              !profileProvider.isUploadingImage)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => profileProvider.clearSelectedProfileImage(),
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
          if (profileProvider.uploadedImageUrl != null &&
              !profileProvider.isUploadingImage)
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

  Widget _buildProfileImageContent(
    HomeProvider homeProvider,
    ProfileProvider profileProvider,
  ) {
    if (profileProvider.selectedProfileImage != null) {
      return Image.file(
        profileProvider.selectedProfileImage!,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    } else if (homeProvider.userDetails?.profileImage != null &&
        homeProvider.userDetails!.profileImage!.isNotEmpty) {
      return Image.network(
        homeProvider.userDetails!.profileImage!,
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

  Widget _buildFormFields(HomeProvider homeProvider) {
    return Column(
      children: [
        // Debug info
        if (homeProvider.userDetails != null)
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CommonTextWidget(
              text: 'Profile loaded: ${homeProvider.userDetails!.name}',
              fontSize: 12,
              color: Colors.green,
            ),
          ),

        // Editable Name Field
        CommonTextField(
          controller: _nameController,
          labelText: 'Full Name',
          validator: (value) => Validators.required(value, 'full name'),
        ),
        const SizedBox(height: 16),

        // Non-editable Email Field
        CommonTextField(
          controller: _emailController,
          labelText: 'Email',
          keyboardType: TextInputType.emailAddress,
          enabled: false,
          suffixIcon: Icon(
            Icons.lock_outline,
            color: AppConstants.white.withOpacity(0.5),
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: AppConstants.white.withOpacity(0.6),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: CommonTextWidget(
                  text: 'Email cannot be changed for security reasons',
                  fontSize: 12,
                  color: AppConstants.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Non-editable Phone Field
        CommonTextField(
          controller: _phoneController,
          labelText: 'Phone Number',
          keyboardType: TextInputType.phone,
          enabled: false,
          suffixIcon: Icon(
            Icons.lock_outline,
            color: AppConstants.white.withOpacity(0.5),
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: AppConstants.white.withOpacity(0.6),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: CommonTextWidget(
                  text: 'Phone number cannot be changed for security reasons',
                  fontSize: 12,
                  color: AppConstants.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(ProfileProvider profileProvider) {
    return PrimaryButton(
      text: 'Save Changes',
      isLoading:
          profileProvider.updateProfileState == ProfileState.loading ||
          profileProvider.isUploadingImage,
      onPressed: _saveProfile,
      height: 56,
      width: double.infinity,
    );
  }

  Future<void> _pickImage() async {
    try {
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
    } catch (e) {
      context.showErrorSnackBar('Failed to pick image: $e');
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final profileProvider = context.read<ProfileProvider>();

      profileProvider
          .updateProfile(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            dialCode: _dialCode,
          )
          .then((_) {
            if (profileProvider.updateProfileState == ProfileState.success) {
              context.showSuccessSnackBar('Profile updated successfully');
              // Refresh home data to reflect changes
              context.read<HomeProvider>().loadUserDetails(forceRefresh: true);
              Navigator.of(context).pop();
            } else if (profileProvider.updateProfileState ==
                ProfileState.error) {
              context.showErrorSnackBar(
                profileProvider.updateProfileError ??
                    'Failed to update profile',
              );
            }
          });
    }
  }
}
