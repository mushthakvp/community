import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../providers/create_job_provider.dart';

class JobFormStepper extends StatelessWidget {
  const JobFormStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildStep(
                context: context,
                stepNumber: 1,
                title: 'Profile Insights',
                isActive: provider.currentStep == 0,
                isCompleted: provider.currentStep > 0,
                onTap: () => provider.setCurrentStep(0),
              ),
              Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: provider.currentStep > 0
                        ? AppConstants.appPrimaryColor
                        : AppConstants.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
              _buildStep(
                context: context,
                stepNumber: 2,
                title: 'Job Details',
                isActive: provider.currentStep == 1,
                isCompleted: false,
                onTap: () => provider.setCurrentStep(1),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStep({
    required BuildContext context,
    required int stepNumber,
    required String title,
    required bool isActive,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppConstants.appPrimaryColor
                  : isActive
                  ? AppConstants.appPrimaryColor
                  : const Color(0xFF262626),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: AppConstants.black, size: 20)
                  : CommonTextWidget(
                      text: stepNumber.toString(),
                      color: isActive
                          ? AppConstants.black
                          : AppConstants.white.withOpacity(0.6),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
            ),
          ),
          const SizedBox(height: 8),
          CommonTextWidget(
            text: title,
            color: isActive
                ? AppConstants.white
                : AppConstants.white.withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
