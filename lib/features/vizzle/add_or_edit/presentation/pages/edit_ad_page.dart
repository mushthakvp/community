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

class EditAdPage extends StatefulWidget {
  final String adId;
  final Map<String, dynamic>? adData;

  const EditAdPage({super.key, required this.adId, this.adData});

  @override
  State<EditAdPage> createState() => _EditAdPageState();
}

class _EditAdPageState extends State<EditAdPage> {
  final _formKey = GlobalKey<FormState>();
  late AddEditProvider _provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = context.read<AddEditProvider>();
      _provider.getCitiesAndCategories();
      _loadExistingAdData();
    });
  }

  void _loadExistingAdData() {
    if (widget.adData != null) {
      final data = widget.adData!;

      // Load text data
      _provider.titleController.text = data['title'] ?? '';
      _provider.descriptionController.text = data['description'] ?? '';
      _provider.priceController.text = data['price']?.toString() ?? '';
      _provider.phoneController.text = data['phone'] ?? '';
      _provider.addressController.text = data['address'] ?? '';

      // Load selected values
      if (data['district'] != null) {
        _provider.selectCity(data['district']);
      }

      // Load location if available
      if (data['latitude'] != null && data['longitude'] != null) {
        _provider.updateLocation(
          double.parse(data['latitude'].toString()),
          double.parse(data['longitude'].toString()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: "Edit Ad", showBackButton: true),
      body: Consumer<AddEditProvider>(
        builder: (context, provider, child) {
          if (provider.state == AddEditState.loading) {
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

                  // Update Button
                  PrimaryButton(
                    text: "Update Ad",
                    isLoading: provider.state == AddEditState.loading,
                    onPressed: () => _updateAd(provider),
                    width: double.infinity,
                    height: 50,
                  ),
                  const SizedBox(height: 16),
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
          text: "Edit Your Ad",
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: "Make changes to improve your ad's visibility",
          fontSize: 14,
          color: AppConstants.white.withOpacity(0.7),
        ),
      ],
    );
  }

  void _updateAd(AddEditProvider provider) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Show confirmation dialog
    final confirmed = await _showUpdateConfirmationDialog();
    if (!confirmed) return;

    try {
      await provider.updateAd(widget.adId);

      if (provider.state == AddEditState.success) {
        _showSuccessDialog();
      } else if (provider.state == AddEditState.error) {
        _showErrorDialog(provider.errorMessage ?? 'Failed to update ad');
      }
    } catch (e) {
      _showErrorDialog('An unexpected error occurred');
    }
  }

  Future<bool> _showUpdateConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppConstants.surfaceVariant,
            title: const CommonTextWidget(
              text: "Update Ad",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            content: const CommonTextWidget(
              text: "Are you sure you want to update this ad?",
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
                  text: "Update",
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
          text: "Your ad has been updated successfully!",
          fontSize: 14,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
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
