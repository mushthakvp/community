import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../providers/create_job_provider.dart';

class DescriptionInput extends StatelessWidget {
  const DescriptionInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: 'Job Description',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
            const SizedBox(height: 8),
            const CommonTextWidget(
              text:
                  'Provide a detailed description of the job role, requirements, and expectations. Minimum 50 words required.',
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: AppConstants.white,
            ),
            const SizedBox(height: 12),
            CommonTextField(
              controller: provider.descriptionController,
              hintText: 'Enter detailed job description...',
              minLines: 5,
              maxLines: 10,
              validator: provider.validateDescription,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 100),
                child: Icon(Icons.description, color: AppConstants.white),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonTextWidget(
                  text:
                      'Word count: ${provider.descriptionController.text.trim().split(' ').where((word) => word.isNotEmpty).length}',
                  fontSize: 12,
                  color: AppConstants.white.withOpacity(0.6),
                ),
                CommonTextWidget(
                  text: 'Minimum: 50 words',
                  fontSize: 12,
                  color: AppConstants.white.withOpacity(0.6),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
