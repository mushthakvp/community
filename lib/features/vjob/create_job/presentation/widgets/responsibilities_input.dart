import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../providers/create_job_provider.dart';

class ResponsibilitiesInput extends StatelessWidget {
  const ResponsibilitiesInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: 'Responsibilities',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
            const SizedBox(height: 8),
            const CommonTextWidget(
              text:
                  'List the key responsibilities for this position. Add one responsibility at a time.',
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: AppConstants.white,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CommonTextField(
                    controller: provider.responsibilityController,
                    hintText: 'Enter a responsibility',
                    onSaved: (_) => provider.addResponsibility(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: provider.addResponsibility,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppConstants.appPrimaryColor,
                    ),
                    child: const Icon(Icons.add, color: AppConstants.black),
                  ),
                ),
              ],
            ),
            if (provider.responsibilities.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppConstants.white.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonTextWidget(
                      text: 'Added Responsibilities:',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.white,
                    ),
                    const SizedBox(height: 12),
                    ...provider.responsibilities.asMap().entries.map((entry) {
                      final responsibility = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppConstants.appPrimaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CommonTextWidget(
                                text: responsibility,
                                color: AppConstants.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  provider.removeResponsibility(responsibility),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
