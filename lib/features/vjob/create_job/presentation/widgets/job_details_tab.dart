import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../providers/create_job_provider.dart';

class JobDetailsTab extends StatelessWidget {
  const JobDetailsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDescriptionSection(provider),
            const SizedBox(height: 24),
            _buildResponsibilitiesSection(provider),
          ],
        );
      },
    );
  }

  Widget _buildDescriptionSection(CreateJobProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Job Description'),
        const SizedBox(height: 4),
        CommonTextWidget(
          text:
              'Provide a detailed description of the job role (minimum 50 words)',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.7),
        ),
        const SizedBox(height: 8),
        CommonTextField(
          controller: provider.descriptionController,
          hintText: 'Enter job description...',
          maxLines: 8,
          minLines: 6,
          onChanged: (value) => provider.setDescription(value),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Job description is required';
            }
            if (value.trim().split(' ').length < 50) {
              return 'Description must be at least 50 words';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildResponsibilitiesSection(CreateJobProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Responsibilities'),
        const SizedBox(height: 4),
        CommonTextWidget(
          text: 'Add key responsibilities for this role',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.7),
        ),
        const SizedBox(height: 8),
        _buildResponsibilityInput(provider),
        const SizedBox(height: 12),
        _buildResponsibilityChips(provider),
      ],
    );
  }

  Widget _buildResponsibilityInput(CreateJobProvider provider) {
    return Row(
      children: [
        Expanded(
          child: CommonTextField(
            controller: provider.responsibilityController,
            hintText: 'Add a responsibility...',
            onSaved: (_) => provider.addResponsibility(),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: provider.addResponsibility,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppConstants.appPrimaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add, color: AppConstants.black, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildResponsibilityChips(CreateJobProvider provider) {
    if (provider.responsibilities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConstants.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppConstants.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppConstants.white.withOpacity(0.6),
              size: 20,
            ),
            const SizedBox(width: 8),
            CommonTextWidget(
              text:
                  'Add responsibilities to help candidates understand the role better',
              fontSize: 12,
              color: AppConstants.white.withOpacity(0.6),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: provider.responsibilities.map((responsibility) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppConstants.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppConstants.white.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: CommonTextWidget(
                  text: responsibility,
                  fontSize: 12,
                  color: AppConstants.white,
                  maxLines: 2,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => provider.removeResponsibility(responsibility),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: AppConstants.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
}
