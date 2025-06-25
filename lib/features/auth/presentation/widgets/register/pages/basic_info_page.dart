import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../../../../core/widgets/inputs/text_field.dart';
import '../../../providers/auth_provider.dart';
import '../../profile_image_picker.dart';

class BasicInfoPage extends StatelessWidget {
  const BasicInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CommonTextWidget(
                text: 'Basic Information',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.white,
              ),
              const SizedBox(height: 8),
              CommonTextWidget(
                text: 'Let\'s start with the basics',
                fontSize: 16,
                color: AppConstants.white.withOpacity(0.7),
              ),
              const SizedBox(height: 32),
              ProfileImagePicker(
                onImageSelected: (image) {
                  authProvider.setProfileImage(image);
                },
              ),
              const SizedBox(height: 24),
              CommonTextField(
                controller: authProvider.nameController,
                hintText: 'Full Name *',
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: AppConstants.white,
                ),
                validator: (value) => Validators.required(value, 'name'),
              ),
              const SizedBox(height: 20),
              CommonTextField(
                controller: authProvider.emailController,
                hintText: 'Email Address *',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppConstants.white,
                ),
                validator: Validators.email,
              ),
              const SizedBox(height: 20),
              CommonTextField(
                controller: authProvider.phoneController,
                hintText: 'Phone Number *',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(
                  Icons.phone_outlined,
                  color: AppConstants.white,
                ),
                validator: Validators.phone,
              ),
            ],
          );
        },
      ),
    );
  }
}
