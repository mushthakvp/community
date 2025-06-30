import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../providers/add_edit_provider.dart';
import '../utils/validation_utils.dart';
import '../widgets/category_selection_widget.dart';
import '../widgets/form_section_widget.dart';
import '../widgets/image_picker_widget.dart';
import '../widgets/location_picker_widget.dart';

class CreateAdPage extends StatefulWidget {
  const CreateAdPage({super.key});

  @override
  State<CreateAdPage> createState() => _CreateAdPageState();
}

class _CreateAdPageState extends State<CreateAdPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddEditProvider>().getCitiesAndCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: "Create Ad", showBackButton: true),
      body: Consumer<AddEditProvider>(
        builder: (context, provider, child) {
          if (provider.state == AddEditState.loading &&
              provider.citiesResponse == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppConstants.appPrimaryColor,
              ),
            );
          }
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildHeaderSection(),
                  const SizedBox(height: 24),
                  // Images Section
                  FormSectionWidget(
                    title: "Photos",
                    subtitle: "Add up to 10 photos to showcase your item",
                    child: const ImagePickerWidget(),
                  ),
                  const SizedBox(height: 24),
                  // Basic Information
                  FormSectionWidget(
                    title: "Basic Information",
                    child: Column(
                      children: [
                        CommonTextField(
                          controller: provider.titleController,
                          hintText: "Enter title",
                          validator: ValidationUtils.validateTitle,
                        ),
                        const SizedBox(height: 16),
                        CommonTextField(
                          controller: provider.descriptionController,
                          hintText: "Describe your item",
                          maxLines: 4,
                          validator: ValidationUtils.validateDescription,
                        ),
                        const SizedBox(height: 16),
                        CommonTextField(
                          controller: provider.priceController,
                          hintText: "Price (optional)",
                          keyboardType: TextInputType.number,
                          validator: ValidationUtils.validatePrice,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Category Selection
                  FormSectionWidget(
                    title: "Category",
                    subtitle: "Choose the right category for better reach",
                    child: const CategorySelectionWidget(),
                  ),
                  const SizedBox(height: 24),
                  // Location
                  FormSectionWidget(
                    title: "Location",
                    subtitle: "Where is your item located?",
                    child: const LocationPickerWidget(),
                  ),
                  const SizedBox(height: 24),
                  // Contact Information
                  FormSectionWidget(
                    title: "Contact Information",
                    child: CommonTextField(
                      controller: provider.phoneController,
                      hintText: "Phone number",
                      keyboardType: TextInputType.phone,
                      validator: ValidationUtils.validatePhone,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Create Button
                  PrimaryButton(
                    text: "Post Ad",
                    isLoading: provider.state == AddEditState.loading,
                    onPressed: () => _createAd(provider),
                    width: double.infinity,
                    height: 50,
                  ),
                  const SizedBox(height: 16),
                  // Terms and Conditions
                  _buildTermsSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextWidget(
          text: "Create Your Ad",
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: "Fill in the details to create your ad",
          fontSize: 14,
          color: AppConstants.white.withOpacity(0.7),
        ),
      ],
    );
  }

  Widget _buildTermsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppConstants.appPrimaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const CommonTextWidget(
                text: "Terms & Conditions",
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          const SizedBox(height: 8),
          CommonTextWidget(
            text:
                "By posting this ad, you agree to our Terms of Service and confirm that the information provided is accurate.",
            fontSize: 12,
            color: AppConstants.white.withOpacity(0.7),
          ),
        ],
      ),
    );
  }

  void _createAd(AddEditProvider provider) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final confirmed = await _showCreateConfirmationDialog();
    if (!confirmed) return;
    try {
      await provider.createAd();
      if (provider.state == AddEditState.success) {
        _showSuccessDialog();
      } else if (provider.state == AddEditState.error) {
        _showErrorDialog(provider.errorMessage ?? 'Failed to create ad');
      }
    } catch (e) {
      _showErrorDialog('An unexpected error occurred');
    }
  }

  Future<bool> _showCreateConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppConstants.surfaceVariant,
            title: const CommonTextWidget(
              text: "Post Ad",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            content: const CommonTextWidget(
              text: "Are you sure you want to post this ad?",
              fontSize: 14,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: CommonTextWidget(
                  text: "Cancel",
                  color: AppConstants.white.withOpacity(0.7),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const CommonTextWidget(
                  text: "Post",
                  color: AppConstants.appPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.surfaceVariant,
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 24),
            SizedBox(width: 8),
            CommonTextWidget(
              text: "Success!",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        content: const CommonTextWidget(
          text: "Your ad has been posted successfully!",
          fontSize: 14,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const CommonTextWidget(
              text: "OK",
              color: AppConstants.appPrimaryColor,
              fontWeight: FontWeight.w600,
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
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 24),
            SizedBox(width: 8),
            CommonTextWidget(
              text: "Error",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        content: CommonTextWidget(text: message, fontSize: 14),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CommonTextWidget(
              text: "OK",
              color: AppConstants.appPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
