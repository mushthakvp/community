import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vivera/core/widgets/buttons/primary_button.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/spacer_widget.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/place_add_provider.dart';
import '../utils/form_validators.dart';
import '../widgets/category_specific_forms.dart';
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
  void initState() {
    super.initState();
    // Set default location if not set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PlaceAddProvider>();
      if (provider.latitude == null || provider.longitude == null) {
        // Set default to Kannur, Kerala
        provider.setLocation(11.8745, 75.3704, 'Kannur, Kerala, India');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Create Your Ad', showBackButton: true),
      body: Consumer<PlaceAddProvider>(
        builder: (context, provider, child) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selected city and category info
                  _buildSelectionInfo(provider),
                  AppSpacing.verticalXL,

                  // Image picker
                  const ImagePickerWidget(),
                  AppSpacing.verticalXL,

                  // Title field
                  CustomFormField(
                    controller: provider.titleController,
                    labelText: 'Title *',
                    hintText: 'Enter a descriptive title',
                    validator: FormValidators.required,
                  ),
                  AppSpacing.verticalMD,

                  // Price field
                  CustomFormField(
                    controller: provider.priceController,
                    labelText: 'Price',
                    hintText: 'Enter price (Optional)',
                    keyboardType: TextInputType.number,
                    validator: FormValidators.price,
                  ),
                  AppSpacing.verticalMD,

                  // Phone field
                  CustomFormField(
                    controller: provider.phoneController,
                    labelText: 'Phone Number *',
                    hintText: 'Enter your phone number',
                    keyboardType: TextInputType.phone,
                    validator: FormValidators.phone,
                    maxLength: 10,
                  ),
                  AppSpacing.verticalMD,

                  // Description field
                  CustomFormField(
                    controller: provider.descriptionController,
                    labelText: 'Description *',
                    hintText: 'Describe your item in detail',
                    maxLines: 4,
                    validator: FormValidators.required,
                  ),
                  AppSpacing.verticalXL,

                  // Category specific fields
                  _buildCategorySpecificFields(provider),

                  // Location section
                  _buildLocationSection(provider),
                  AppSpacing.verticalXL,

                  // Create ad button
                  _buildCreateAdButton(provider),
                  AppSpacing.verticalXL,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectionInfo(PlaceAddProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.appPrimaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonTextWidget(
            text: 'Ad Details',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          AppSpacing.verticalSM,
          if (provider.selectedCity != null) ...[
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppConstants.appPrimaryColor,
                ),
                const SizedBox(width: 8),
                CommonTextWidget(
                  text: 'City: ${provider.selectedCity}',
                  fontSize: 14,
                ),
              ],
            ),
            AppSpacing.verticalSM,
          ],
          if (provider.selectedCategory != null) ...[
            Row(
              children: [
                const Icon(
                  Icons.category,
                  size: 16,
                  color: AppConstants.appPrimaryColor,
                ),
                const SizedBox(width: 8),
                CommonTextWidget(
                  text: 'Category: ${provider.selectedCategory!.name}',
                  fontSize: 14,
                ),
              ],
            ),
            if (provider.selectedSubCategory != null) ...[
              AppSpacing.verticalSM,
              Row(
                children: [
                  const Icon(
                    Icons.subdirectory_arrow_right,
                    size: 16,
                    color: AppConstants.appPrimaryColor,
                  ),
                  const SizedBox(width: 8),
                  CommonTextWidget(
                    text: 'Subcategory: ${provider.selectedSubCategory!.name}',
                    fontSize: 14,
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildCategorySpecificFields(PlaceAddProvider provider) {
    final categoryName = provider.selectedCategory?.name.toLowerCase() ?? '';

    if (categoryName.contains('motor')) {
      return Column(
        children: [
          const CommonTextWidget(
            text: 'Vehicle Details',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          AppSpacing.verticalMD,
          MotorSpecificFields(
            category: provider.selectedSubCategory?.name ?? 'General',
          ),
          AppSpacing.verticalXL,
        ],
      );
    } else if (categoryName.contains('electronics') ||
        categoryName.contains('mobile') ||
        categoryName.contains('computer')) {
      return Column(
        children: [
          const CommonTextWidget(
            text: 'Item Details',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          AppSpacing.verticalMD,
          if (provider.selectedSubCategory?.name.toLowerCase().contains(
                    'mobile',
                  ) ==
                  true ||
              provider.selectedSubCategory?.name.toLowerCase().contains(
                    'phone',
                  ) ==
                  true)
            const MobileSpecificFields()
          else
            ElectronicsSpecificFields(
              category: provider.selectedSubCategory?.name ?? 'Electronics',
            ),
          AppSpacing.verticalXL,
        ],
      );
    } else if (categoryName.contains('property')) {
      return Column(
        children: [
          const CommonTextWidget(
            text: 'Property Details',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          AppSpacing.verticalMD,
          if (categoryName.contains('rent'))
            const RentSpecificFields()
          else
            PropertySpecificFields(
              propertyType: provider.selectedSubCategory?.name ?? 'Property',
            ),
          AppSpacing.verticalXL,
        ],
      );
    } else if (categoryName.contains('farm') ||
        categoryName.contains('fresh')) {
      return Column(
        children: [
          const CommonTextWidget(
            text: 'Farm Fresh Details',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          AppSpacing.verticalMD,
          const FarmFreshSpecificFields(),
          AppSpacing.verticalXL,
        ],
      );
    } else if (categoryName.contains('community')) {
      return Column(
        children: [
          const CommonTextWidget(
            text: 'Additional Details',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          AppSpacing.verticalMD,
          const CommunitySpecificFields(),
          AppSpacing.verticalXL,
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildLocationSection(PlaceAddProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CommonTextWidget(
              text: 'Location',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            TextButton.icon(
              onPressed: () {
                context.push(RouteConstants.locationPicker);
              },
              icon: const Icon(
                Icons.edit_location,
                size: 16,
                color: AppConstants.appPrimaryColor,
              ),
              label: const CommonTextWidget(
                text: 'Change',
                fontSize: 14,
                color: AppConstants.appPrimaryColor,
              ),
            ),
          ],
        ),
        AppSpacing.verticalMD,
        Container(
          decoration: BoxDecoration(
            color: AppConstants.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppConstants.appPrimaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              const MapWidget(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppConstants.appPrimaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CommonTextWidget(
                        text: provider.address ?? 'Kannur, Kerala, India',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAdButton(PlaceAddProvider provider) {
    if (provider.publishAddStatus == 0) {
      return const Center(child: LoadingWidget(message: 'Creating your ad...'));
    }

    return PrimaryButton(
      text: 'Publish Ad',
      onPressed: () {
        if (_validateForm(provider)) {
          _createAd(provider);
        }
      },
      backgroundColor: AppConstants.appPrimaryColor,
      textColor: AppConstants.black,
      borderRadius: 12,
      height: 56,
    );
  }

  bool _validateForm(PlaceAddProvider provider) {
    // Validate form fields
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    // Check if images are selected
    if (provider.selectedImages.isEmpty) {
      _showErrorDialog('Please add at least one image');
      return false;
    }

    // Check if location is set
    if (provider.latitude == null || provider.longitude == null) {
      _showErrorDialog('Please select a location');
      return false;
    }

    // Check if city and category are selected
    if (provider.selectedCity == null) {
      _showErrorDialog('Please select a city');
      return false;
    }

    if (provider.selectedCategory == null) {
      _showErrorDialog('Please select a category');
      return false;
    }

    return true;
  }

  void _createAd(PlaceAddProvider provider) async {
    await provider.createAd();

    if (!mounted) return;

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppConstants.appPrimaryColor,
              size: 32,
            ),
            SizedBox(width: 12),
            CommonTextWidget(
              text: 'Success!',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
          ],
        ),
        content: const CommonTextWidget(
          text: 'Your ad has been created successfully and is now live.',
          fontSize: 16,
          color: AppConstants.white,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate back to home and clear the stack
              context.go(RouteConstants.vizzleHome);
              // Clear provider data
              context.read<PlaceAddProvider>().clearAllData();
            },
            child: const CommonTextWidget(
              text: 'OK',
              fontSize: 16,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: AppConstants.error, size: 32),
            SizedBox(width: 12),
            CommonTextWidget(
              text: 'Error',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
          ],
        ),
        content: CommonTextWidget(
          text: message,
          fontSize: 16,
          color: AppConstants.white,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const CommonTextWidget(
              text: 'OK',
              fontSize: 16,
              color: AppConstants.appPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
