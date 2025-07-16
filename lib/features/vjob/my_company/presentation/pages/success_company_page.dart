import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class SuccessCompanyPage extends StatelessWidget {
  const SuccessCompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: AppBar(
        backgroundColor: AppConstants.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConstants.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 32),
            const CommonTextWidget(
              text: 'Application Submitted Successfully!',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CommonTextWidget(
              text:
                  'We will inform you about the next steps.\nPlease sit tight and wait for our response.',
              fontSize: 16,
              color: AppConstants.white.withOpacity(0.6),
              align: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                context.pushReplacementNamed('/vjob/my-jobs');
              },
              child: const CommonTextWidget(
                text: 'View your application in My Jobs',
                fontSize: 14,
                color: AppConstants.appPrimaryColor,
                align: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.pushReplacementNamed('/vjob/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.appPrimaryColor,
                  foregroundColor: AppConstants.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const CommonTextWidget(
                  text: 'Return to Job Search',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
