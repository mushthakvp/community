import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../providers/create_job_provider.dart';

class SkillsInput extends StatelessWidget {
  const SkillsInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: 'Skills Required',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
            const SizedBox(height: 8),
            const CommonTextWidget(
              text:
                  'Add your technical or soft skills such as salesforce, communication skills etc.',
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: AppConstants.white,
            ),
            const SizedBox(height: 12),
            CommonTextField(
              controller: provider.skillController,
              hintText: 'Enter skills you use at work eg. good communication',
              minLines: 3,
              maxLines: 5,
              onChanged: (value) {
                if (value.contains(',')) {
                  final skill = value.replaceAll(',', '').trim();
                  provider.addSkill(skill);
                }
              },
              onSaved: (p0) => provider.addSkill(p0 ?? ''),
            ),
            if (provider.skills.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: provider.skills.map((skill) {
                  return Chip(
                    backgroundColor: AppConstants.black,
                    side: BorderSide(
                      color: AppConstants.white.withOpacity(0.2),
                    ),
                    label: CommonTextWidget(
                      text: skill,
                      color: AppConstants.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                    deleteIcon: const Icon(
                      Icons.close,
                      color: AppConstants.white,
                      size: 16,
                    ),
                    onDeleted: () => provider.removeSkill(skill),
                  );
                }).toList(),
              ),
            ],
          ],
        );
      },
    );
  }
}
