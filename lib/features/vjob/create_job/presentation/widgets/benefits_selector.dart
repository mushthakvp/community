import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../providers/create_job_provider.dart';

class BenefitsSelector extends StatelessWidget {
  const BenefitsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, child) {
        return _buildOptionsSection(
          title: 'Benefits',
          options: provider.benefitsOptions,
          selectedOptions: provider.selectedBenefits,
          onToggle: provider.toggleBenefit,
        );
      },
    );
  }

  Widget _buildOptionsSection({
    required String title,
    required List<String> options,
    required List<String> selectedOptions,
    required Function(String) onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          text: title,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedOptions.contains(option);

            return GestureDetector(
              onTap: () => onToggle(option),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isSelected
                      ? AppConstants.appPrimaryColor.withOpacity(0.5)
                      : AppConstants.black,
                  border: Border.all(
                    color: isSelected
                        ? AppConstants.appPrimaryColor
                        : AppConstants.white.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.add_circle_outline,
                      color: AppConstants.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    CommonTextWidget(
                      text: option,
                      color: AppConstants.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
