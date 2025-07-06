import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../providers/create_job_provider.dart';

class SalaryInput extends StatelessWidget {
  const SalaryInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: 'Pay (Optional)',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
            const SizedBox(height: 8),
            const CommonTextWidget(
              text:
                  'Review the pay we estimated for your job and adjust it as needed. Check your local minimum wage',
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: AppConstants.white,
            ),
            const SizedBox(height: 12),
            const CommonTextWidget(
              text: 'Minimum Salary',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppConstants.white,
            ),
            const SizedBox(height: 8),
            CommonTextField(
              controller: provider.minimumSalaryController,
              hintText: 'Enter Minimum Salary',
              keyboardType: TextInputType.number,
              validator: provider.validateSalary,
              prefixIcon: const Icon(
                Icons.currency_rupee,
                color: AppConstants.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
