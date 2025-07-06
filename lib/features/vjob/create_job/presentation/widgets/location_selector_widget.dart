import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../providers/create_job_provider.dart';

class LocationSelectorWidget extends StatelessWidget {
  const LocationSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('Location'),
            const SizedBox(height: 8),
            _buildCountryField(),
            const SizedBox(height: 16),
            _buildStateField(context, provider),
            const SizedBox(height: 16),
            _buildCityField(context, provider),
          ],
        );
      },
    );
  }

  Widget _buildCountryField() {
    return CommonTextField(
      hintText: 'India',
      readOnly: true,
      enabled: false,
      prefixIcon: const Icon(Icons.public, color: AppConstants.white, size: 20),
      suffixIcon: Icon(
        Icons.keyboard_arrow_down,
        color: AppConstants.white.withOpacity(0.5),
        size: 20,
      ),
    );
  }

  Widget _buildStateField(BuildContext context, CreateJobProvider provider) {
    return CommonTextField(
      hintText: provider.selectedState.isEmpty
          ? 'Select State'
          : provider.selectedState,
      readOnly: true,
      onTap: () => _navigateToStateSelection(context),
      prefixIcon: const Icon(
        Icons.location_on_outlined,
        color: AppConstants.white,
        size: 20,
      ),
      suffixIcon: const Icon(
        Icons.keyboard_arrow_down,
        color: AppConstants.white,
        size: 20,
      ),
    );
  }

  Widget _buildCityField(BuildContext context, CreateJobProvider provider) {
    return CommonTextField(
      hintText: provider.selectedCity.isEmpty
          ? 'Select City'
          : provider.selectedCity,
      readOnly: true,
      onTap: () => _navigateToCitySelection(context, provider),
      prefixIcon: const Icon(
        Icons.location_city_outlined,
        color: AppConstants.white,
        size: 20,
      ),
      suffixIcon: const Icon(
        Icons.keyboard_arrow_down,
        color: AppConstants.white,
        size: 20,
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return CommonTextWidget(
      text: label,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppConstants.white,
    );
  }

  void _navigateToStateSelection(BuildContext context) {
    // Navigate to state selection screen
    // This should integrate with your existing state selection logic
    context.push('/location/states').then((selectedState) {
      if (selectedState != null) {
        final provider = context.read<CreateJobProvider>();
        provider.setLocation(selectedState as String, '');
      }
    });
  }

  void _navigateToCitySelection(
    BuildContext context,
    CreateJobProvider provider,
  ) {
    if (provider.selectedState.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a state first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Navigate to city selection screen
    context.push('/location/cities/${provider.selectedState}').then((
      selectedCity,
    ) {
      if (selectedCity != null) {
        provider.setLocation(provider.selectedState, selectedCity as String);
      }
    });
  }
}
