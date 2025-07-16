import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../providers/create_job_provider.dart';

class SkillsInputWidget extends StatefulWidget {
  const SkillsInputWidget({super.key});

  @override
  State<SkillsInputWidget> createState() => _SkillsInputWidgetState();
}

class _SkillsInputWidgetState extends State<SkillsInputWidget> {
  final TextEditingController _skillController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _skillController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(),
            const SizedBox(height: 8),
            _buildSkillInput(provider),
            const SizedBox(height: 16),
            _buildSkillsDisplay(provider),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextWidget(
          text: 'Required Skills',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        const SizedBox(height: 4),
        CommonTextWidget(
          text:
              'Add technical or soft skills. Use comma to separate multiple skills.',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.7),
        ),
      ],
    );
  }

  Widget _buildSkillInput(CreateJobProvider provider) {
    return CommonTextField(
      controller: _skillController,
      focusNode: _focusNode,
      hintText: 'e.g., Flutter, Communication, Problem Solving',
      maxLines: 3,
      onChanged: _handleTextChange,
      onSaved: (_) => _addCurrentSkill(provider),
      suffixIcon: GestureDetector(
        onTap: () => _addCurrentSkill(provider),
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConstants.appPrimaryColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.add, color: AppConstants.black, size: 20),
        ),
      ),
    );
  }

  Widget _buildSkillsDisplay(CreateJobProvider provider) {
    if (provider.skills.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CommonTextWidget(
              text: 'Added Skills',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppConstants.white,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CommonTextWidget(
                text: '${provider.skills.length}',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppConstants.appPrimaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: provider.skills
              .map((skill) => _buildSkillChip(skill, provider))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSkillChip(String skill, CreateJobProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppConstants.appPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.appPrimaryColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.code, size: 14, color: AppConstants.appPrimaryColor),
          const SizedBox(width: 6),
          Flexible(
            child: CommonTextWidget(
              text: skill,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppConstants.appPrimaryColor,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => provider.removeSkill(skill),
            child: Icon(
              Icons.close,
              size: 14,
              color: AppConstants.appPrimaryColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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
            Icons.lightbulb_outline,
            color: AppConstants.white.withOpacity(0.6),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CommonTextWidget(
              text:
                  'Add skills to help candidates understand what\'s required for this role',
              fontSize: 12,
              color: AppConstants.white.withOpacity(0.6),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  void _handleTextChange(String value) {
    if (value.contains(',')) {
      final provider = context.read<CreateJobProvider>();
      final skills = value.split(',');

      for (String skill in skills) {
        final trimmedSkill = skill.trim();
        if (trimmedSkill.isNotEmpty) {
          provider.addSkill(trimmedSkill);
        }
      }

      _skillController.clear();
    }
  }

  void _addCurrentSkill(CreateJobProvider provider) {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty) {
      provider.addSkill(skill);
      _skillController.clear();
    }
  }
}
