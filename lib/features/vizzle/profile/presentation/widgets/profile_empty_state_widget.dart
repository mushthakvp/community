import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class ProfileEmptyStateWidget extends StatelessWidget {
  const ProfileEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppConstants.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.person_outline,
                size: 60,
                color: AppConstants.white.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 24),
            const CommonTextWidget(
              text: 'Profile Not Available',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text:
                  'We couldn\'t load your profile information.\nPlease try again later.',
              fontSize: 14,
              color: AppConstants.white.withOpacity(0.6),
              align: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.appPrimaryColor,
                foregroundColor: AppConstants.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
