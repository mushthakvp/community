import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../providers/create_job_provider.dart';

class LocationSelector extends StatelessWidget {
  const LocationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: 'Location',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppConstants.white,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CommonTextField(
                    hintText: 'State',
                    readOnly: true,
                    onTap: () => _selectState(context, provider),
                    controller: TextEditingController(
                      text: provider.selectedState,
                    ),
                    suffixIcon: const Icon(
                      Icons.arrow_drop_down,
                      color: AppConstants.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CommonTextField(
                    hintText: 'City',
                    readOnly: true,
                    onTap: () => _selectCity(context, provider),
                    controller: TextEditingController(
                      text: provider.selectedCity,
                    ),
                    suffixIcon: const Icon(
                      Icons.arrow_drop_down,
                      color: AppConstants.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _selectState(BuildContext context, CreateJobProvider provider) {
    // This would typically navigate to a state selection screen
    // For now, we'll show a simple dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const CommonTextWidget(
          text: 'Select State',
          color: AppConstants.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: ['Kerala', 'Karnataka', 'Tamil Nadu', 'Andhra Pradesh']
                .map(
                  (state) => ListTile(
                    title: CommonTextWidget(
                      text: state,
                      color: AppConstants.white,
                      fontSize: 14,
                    ),
                    onTap: () {
                      provider.setLocation(state: state);
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  void _selectCity(BuildContext context, CreateJobProvider provider) {
    if (provider.selectedState.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a state first')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const CommonTextWidget(
          text: 'Select City',
          color: AppConstants.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: ['Kochi', 'Trivandrum', 'Kozhikode', 'Thrissur']
                .map(
                  (city) => ListTile(
                    title: CommonTextWidget(
                      text: city,
                      color: AppConstants.white,
                      fontSize: 14,
                    ),
                    onTap: () {
                      provider.setLocation(city: city);
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
