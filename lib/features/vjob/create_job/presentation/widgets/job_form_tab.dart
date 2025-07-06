import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/dropdown_widget.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../providers/create_job_provider.dart';
import 'chip_selector_widget.dart';
import 'custom_dropdown_field.dart';
import 'location_selector_widget.dart';
import 'skills_input_widget.dart';

class JobFormTab extends StatelessWidget {
  const JobFormTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildJobTitleSection(provider),
            const SizedBox(height: 24),
            const LocationSelectorWidget(),
            const SizedBox(height: 24),
            _buildWorkStyleSection(provider),
            const SizedBox(height: 24),
            _buildPositionsSection(provider),
            const SizedBox(height: 24),
            _buildScheduleSection(provider),
            const SizedBox(height: 24),
            _buildBenefitsSection(provider),
            const SizedBox(height: 24),
            _buildLanguagesSection(provider),
            const SizedBox(height: 24),
            _buildSalarySection(provider),
            const SizedBox(height: 24),
            _buildEducationSection(provider),
            const SizedBox(height: 24),
            const SkillsInputWidget(),
          ],
        );
      },
    );
  }

  Widget _buildJobTitleSection(CreateJobProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Job Title'),
        const SizedBox(height: 8),
        CustomDropdownField(
          value: provider.selectedTitle,
          items: provider.jobTitles.map((title) => title.name).toList(),
          hintText: 'Enter or select job title',
          onChanged: (value) => provider.setTitle(value ?? ''),
          onCreateNew: (value) async {
            final success = await provider.createJobTitle(value);
            if (!success) {
              // Show error message
            }
          },
        ),
      ],
    );
  }

  Widget _buildWorkStyleSection(CreateJobProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Work Style'),
        const SizedBox(height: 8),
        CommonDropdown<String>(
          value: provider.selectedWorkStyle.isEmpty
              ? null
              : provider.selectedWorkStyle,
          items: CreateJobProvider.workStyles
              .map(
                (style) => DropdownMenuItem(
                  value: style,
                  child: CommonTextWidget(
                    text: style,
                    color: AppConstants.white,
                    fontSize: 14,
                  ),
                ),
              )
              .toList(),
          hintText: 'Select work style',
          onChanged: (value) => provider.setWorkStyle(value ?? ''),
        ),
      ],
    );
  }

  Widget _buildPositionsSection(CreateJobProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Positions'),
        const SizedBox(height: 12),
        ChipSelectorWidget(
          items: CreateJobProvider.positions,
          selectedItems: provider.selectedPositions,
          onItemToggled: provider.togglePosition,
        ),
      ],
    );
  }

  Widget _buildScheduleSection(CreateJobProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Schedule'),
        const SizedBox(height: 12),
        ChipSelectorWidget(
          items: CreateJobProvider.schedules,
          selectedItems: provider.selectedSchedule,
          onItemToggled: provider.toggleSchedule,
        ),
      ],
    );
  }

  Widget _buildBenefitsSection(CreateJobProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Benefits'),
        const SizedBox(height: 12),
        ChipSelectorWidget(
          items: CreateJobProvider.benefits,
          selectedItems: provider.selectedBenefits,
          onItemToggled: provider.toggleBenefit,
        ),
      ],
    );
  }

  Widget _buildLanguagesSection(CreateJobProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Languages'),
        const SizedBox(height: 12),
        ChipSelectorWidget(
          items: CreateJobProvider.languages,
          selectedItems: provider.selectedLanguages,
          onItemToggled: provider.toggleLanguage,
        ),
      ],
    );
  }

  Widget _buildSalarySection(CreateJobProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Minimum Salary (Optional)'),
        const SizedBox(height: 8),
        CommonTextField(
          controller: provider.salaryController,
          hintText: 'Enter minimum salary',
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final salary = int.tryParse(value) ?? 0;
            provider.setSalary(salary);
          },
          prefixIcon: const Icon(
            Icons.currency_rupee,
            color: AppConstants.white,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildEducationSection(CreateJobProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Education Requirements'),
        const SizedBox(height: 8),
        CommonDropdown<String>(
          value: provider.selectedEducation.isEmpty
              ? null
              : provider.selectedEducation,
          items: CreateJobProvider.educationLevels
              .map(
                (education) => DropdownMenuItem(
                  value: education,
                  child: CommonTextWidget(
                    text: education,
                    color: AppConstants.white,
                    fontSize: 14,
                  ),
                ),
              )
              .toList(),
          hintText: 'Select education requirement',
          onChanged: (value) => provider.setEducation(value ?? ''),
        ),
      ],
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
