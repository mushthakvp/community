import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/app_bar.dart';
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
          CircleAvatar(
            radius: 50,
            backgroundColor: AppConstants.appPrimaryColor,
            backgroundImage: provider.selectedProfileImage != null
                ? FileImage(provider.selectedProfileImage!)
                : null,
            child: provider.selectedProfileImage == null
                ? const Icon(Icons.person, size: 50, color: AppConstants.black)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppConstants.appPrimaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: AppConstants.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
        ),
        const SizedBox(height: 16),
        CommonTextField(
          controller: _phoneController,
          labelText: 'Phone Number',
          keyboardType: TextInputType.phone,
          validator: Validators.phone,
        ),
      ],
    );
  }

  Widget _buildSaveButton(ProfileProvider provider) {
    return PrimaryButton(
      text: 'Save Changes',
      isLoading: provider.updateProfileState == ProfileState.loading,
      onPressed: _saveProfile,
      height: 56,
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      context.read<ProfileProvider>().selectProfileImage(File(pickedFile.path));
    }
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
