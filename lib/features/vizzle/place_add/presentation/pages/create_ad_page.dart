import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivera/core/widgets/buttons/primary_button.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/spacer_widget.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/place_add_provider.dart';
import '../utils/form_validators.dart';
import '../widgets/form_field_widget.dart';
import '../widgets/image_picker_widget.dart';
import '../widgets/map_widget.dart';

class CreateAdPage extends StatefulWidget {
  const CreateAdPage({super.key});

  @override
  State<CreateAdPage> createState() => _CreateAdPageState();
}

class _CreateAdPageState extends State<CreateAdPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(
        title: 'Tell us about your item',
        showBackButton: true,
      ),
      body: Consumer<PlaceAddProvider>(
        builder: (context, provider, child) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image picker
                  const ImagePickerWidget(),
                  AppSpacing.verticalXL,

                  // Title field
                  CustomFormField(
                    controller: provider.titleController,
                    labelText: 'Title',
                    hintText: 'Enter title',
                    validator: FormValidators.required,
                  ),
                  AppSpacing.verticalMD,

                  // Price field
                  CustomFormField(
                    controller: provider.priceController,
                    labelText: 'Price',
                    hintText: 'Enter price',
                    keyboardType: TextInputType.number,
                  ),
                  AppSpacing.verticalMD,

                  // Phone field
                  CustomFormField(
                    controller: provider.phoneController,
                    labelText: 'Phone Number',
                    hintText: 'Enter phone number',
                    keyboardType: TextInputType.phone,
                    validator: FormValidators.phone,
                    maxLength: 10,
                  ),
                  AppSpacing.verticalMD,

                  // Description field
                  CustomFormField(
                    controller: provider.descriptionController,
                    labelText: 'Description',
                    hintText: 'Describe your item',
                    maxLines: 4,
                    validator: FormValidators.required,
                  ),
                  AppSpacing.verticalXL,

                  // Location section
                  const CommonTextWidget(
                    text: 'Location',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  AppSpacing.verticalMD,

                  Container(
                    decoration: BoxDecoration(
                      color: AppConstants.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const MapWidget(),
                        AppSpacing.verticalSM,
                        CommonTextWidget(
                          text: provider.address ?? 'No location selected',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        AppSpacing.verticalSM,
                      ],
                    ),
                  ),
                  AppSpacing.verticalXL,

                  // Create ad button
                  if (provider.isCreatingAd)
                    const Center(
                      child: LoadingWidget(message: 'Creating your ad...'),
                    )
                  else
                    PrimaryButton(
                      text: 'Publish',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _createAd(provider);
                        }
                      },
                      backgroundColor: AppConstants.appPrimaryColor,
                      textColor: AppConstants.black,
                      borderRadius: 10,
                      height: 50,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _createAd(PlaceAddProvider provider) async {
    await provider.createAd();

    final result = provider.adCreationResult;
    if (result != null) {
      if (result.isSuccess) {
        _showSuccessDialog();
      } else {
        _showErrorDialog(result.errorMessage ?? 'Failed to create ad');
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.surfaceVariant,
        title: const CommonTextWidget(
          text: 'Success!',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.appPrimaryColor,
        ),
        content: const CommonTextWidget(
          text: 'Your ad has been created successfully.',
          fontSize: 16,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
              context.read<PlaceAddProvider>().clearAllData();
            },
            child: const CommonTextWidget(
              text: 'OK',
              fontSize: 16,
              color: AppConstants.appPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.surfaceVariant,
        title: const CommonTextWidget(
          text: 'Error',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.error,
        ),
        content: CommonTextWidget(text: message, fontSize: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const CommonTextWidget(
              text: 'OK',
              fontSize: 16,
              color: AppConstants.appPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
