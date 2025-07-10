import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/text_widget.dart';

class NotificationEmptyWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRefresh;

  const NotificationEmptyWidget({
    super.key,
    required this.message,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty state illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.notifications_none_outlined,
                size: 64,
                color: AppConstants.appPrimaryColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),

            // Empty state title
            const CommonTextWidget(
              text: 'No Notifications',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Empty state message
            CommonTextWidget(
              text: message,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppConstants.white.withOpacity(0.7),
              align: TextAlign.center,
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // Additional info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppConstants.white.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppConstants.white.withOpacity(0.6),
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  CommonTextWidget(
                    text: 'We\'ll notify you when there\'s something new',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppConstants.white.withOpacity(0.6),
                    align: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Refresh button
            if (onRefresh != null) ...[
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Refresh',
                onPressed: onRefresh!,
                backgroundColor: Colors.transparent,
                borderColor: AppConstants.appPrimaryColor,
                textColor: AppConstants.appPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 48,
                width: 140,
                borderRadius: 12,
                prefix: const Icon(
                  Icons.refresh,
                  color: AppConstants.appPrimaryColor,
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
