import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class AdsErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AdsErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red.withOpacity(0.7),
            ),

            const SizedBox(height: 24),

            const CommonTextWidget(
              text: 'Oops! Something went wrong',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
              align: TextAlign.center,
            ),

            const SizedBox(height: 12),

            CommonTextWidget(
              text: message,
              fontSize: 14,
              color: AppConstants.white.withOpacity(0.7),
              align: TextAlign.center,
            ),

            const SizedBox(height: 32),

            PrimaryButton(
              text: 'Try Again',
              onPressed: onRetry,
              backgroundColor: AppConstants.appPrimaryColor,
              textColor: AppConstants.black,
              prefix: const Icon(
                Icons.refresh,
                color: AppConstants.black,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
