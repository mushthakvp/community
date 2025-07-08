import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livera/core/widgets/buttons/primary_button.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class CompanySuccessPage extends StatelessWidget {
  const CompanySuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppConstants.appPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(
                    color: AppConstants.appPrimaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 64,
                  color: AppConstants.appPrimaryColor,
                ),
              ),
              const SizedBox(height: 32),
              const CommonTextWidget(
                text: 'Company Registered Successfully!',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppConstants.white,
                align: TextAlign.center,
              ),
              const SizedBox(height: 16),
              CommonTextWidget(
                text:
                    'Your company profile has been created successfully. You can now start posting jobs and managing your recruitment process.',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppConstants.white.withOpacity(0.8),
                align: TextAlign.center,
                maxLines: 3,
              ),
              const SizedBox(height: 48),
              PrimaryButton(
                width: double.infinity,
                onPressed: () => _handleContinue(context),
                height: 56,
                borderRadius: 12,
                backgroundColor: AppConstants.appPrimaryColor,
                text: 'Continue to Dashboard',
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                width: double.infinity,
                onPressed: () => _handleViewProfile(context),
                height: 56,
                borderRadius: 12,
                backgroundColor: Colors.transparent,
                borderColor: AppConstants.appPrimaryColor,
                text: 'View Company Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleContinue(BuildContext context) {
    // Navigate to main dashboard
    context.go('/vjob/dashboard');
  }

  void _handleViewProfile(BuildContext context) {
    // Navigate to company profile page
    context.go('/vjob/company/profile');
  }
}
