import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../vizzle/place_add/presentation/widgets/form_field_widget.dart';
import '../providers/create_company_provider.dart';
import 'image_picker_widget.dart';

class CompanyFormWidget extends StatelessWidget {
  final VoidCallback onLocationTap;

  const CompanyFormWidget({super.key, required this.onLocationTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateCompanyProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Image
            Center(
              child: ImagePickerWidget(
                imageUrl: provider.companyImage,
                isUploading: provider.isUploadingImage,
                uploadProgress: provider.imageUploadProgress,
                onTap: () => provider.pickImage(),
              ),
            ),
            const SizedBox(height: 32),

            // Company Name
            CustomFormField(
              labelText: 'Company Name',
              controller: provider.nameController,
              validator: provider.validateName,
              hintText: 'Enter company name',
            ),
            const SizedBox(height: 20),

            // Email
            CustomFormField(
              labelText: 'Email Address',
              controller: provider.emailController,
              validator: provider.validateEmail,
              keyboardType: TextInputType.emailAddress,
              hintText: 'Enter email address',
            ),
            const SizedBox(height: 20),

            // Phone
            CustomFormField(
              labelText: 'Phone Number',
              controller: provider.phoneController,
              validator: provider.validatePhone,
              keyboardType: TextInputType.phone,
              maxLength: 15,
              hintText: 'Enter phone number',
            ),
            const SizedBox(height: 20),

            // Location
            CustomFormField(
              labelText: 'Company Location',
              controller: provider.locationController,
              readOnly: true,
              onTap: onLocationTap,
              hintText: 'Select location',
              suffixIcon: const Icon(
                Icons.location_on,
                color: AppConstants.appPrimaryColor,
              ),
            ),
            const SizedBox(height: 20),

            // Website (Optional)
            CustomFormField(
              labelText: 'Website (Optional)',
              controller: provider.websiteController,
              validator: provider.validateWebsite,
              keyboardType: TextInputType.url,
              hintText: 'Enter website URL',
            ),
            const SizedBox(height: 20),

            // Description
            CustomFormField(
              labelText: 'Company Description',
              controller: provider.descriptionController,
              validator: provider.validateDescription,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              hintText: 'Enter company description (minimum 50 words)',
            ),
          ],
        );
      },
    );
  }
}
