import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/text_widget.dart';

class NotificationErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? retryButtonText;

  const NotificationErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.retryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Colors.red.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),

            // Error title
            const CommonTextWidget(
              text: 'Something went wrong',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Error message
            CommonTextWidget(
              text: message,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppConstants.white.withOpacity(0.7),
              align: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Error details card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.wifi_off_outlined,
                    color: Colors.red.withOpacity(0.6),
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  CommonTextWidget(
                    text: 'Please check your internet connection and try again',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.red.withOpacity(0.8),
                    align: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Retry button
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              PrimaryButton(
                text: retryButtonText ?? 'Try Again',
                onPressed: onRetry!,
                backgroundColor: AppConstants.appPrimaryColor,
                textColor: AppConstants.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 48,
                width: 140,
                borderRadius: 12,
                prefix: const Icon(
                  Icons.refresh,
                  color: AppConstants.black,
                  size: 20,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
