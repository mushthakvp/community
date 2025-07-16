import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/text_widget.dart';

class EmptyCouponsWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRefresh;

  const EmptyCouponsWidget({super.key, required this.message, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty State Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.local_offer_outlined,
                size: 56,
                color: AppConstants.appPrimaryColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),

            // Empty State Title
            const CommonTextWidget(
              text: 'No Coupons Found',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Empty State Message
            CommonTextWidget(
              text: message,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppConstants.white.withOpacity(0.7),
              align: TextAlign.center,
              maxLines: 2,
            ),

            // Refresh Button
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
                width: 120,
                borderRadius: AppConstants.defaultBorderRadius,
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
