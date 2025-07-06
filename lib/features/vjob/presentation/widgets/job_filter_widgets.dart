import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/vjob_provider.dart';

class JobFilterWidgets extends StatelessWidget {
  const JobFilterWidgets({super.key});

  static const List<String> workStyles = ['Remote', 'Onsite', 'Hybrid'];

  static const List<String> locations = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Hyderabad',
    'Chennai',
    'Pune',
    'Kolkata',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<VJobProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CommonTextWidget(
                  text: 'Filters',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.white,
                ),
                const Spacer(),
                if (provider.selectedLocation.isNotEmpty ||
                    provider.selectedWorkStyle.isNotEmpty)
                  GestureDetector(
                    onTap: provider.clearFilters,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.clear, color: Colors.red, size: 16),
                          SizedBox(width: 4),
                          CommonTextWidget(
                            text: 'Clear',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _buildWorkStyleFilter(provider),
            const SizedBox(height: 12),
            _buildLocationFilter(provider),
          ],
        );
      },
    );
  }

  Widget _buildWorkStyleFilter(VJobProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextWidget(
          text: 'Work Style',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppConstants.white,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: workStyles.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final workStyle = workStyles[index];
              final isSelected = provider.selectedWorkStyle == workStyle;

              return GestureDetector(
                onTap: () =>
                    provider.selectWorkStyle(isSelected ? '' : workStyle),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppConstants.appPrimaryColor
                        : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppConstants.appPrimaryColor
                          : AppConstants.white.withOpacity(0.2),
                    ),
                  ),
                  child: CommonTextWidget(
                    text: workStyle,
                    color: isSelected ? AppConstants.black : AppConstants.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLocationFilter(VJobProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextWidget(
          text: 'Location',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppConstants.white,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: locations.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final location = locations[index];
              final isSelected = provider.selectedLocation == location;

              return GestureDetector(
                onTap: () =>
                    provider.selectLocation(isSelected ? '' : location),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppConstants.appPrimaryColor
                        : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppConstants.appPrimaryColor
                          : AppConstants.white.withOpacity(0.2),
                    ),
                  ),
                  child: CommonTextWidget(
                    text: location,
                    color: isSelected ? AppConstants.black : AppConstants.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
