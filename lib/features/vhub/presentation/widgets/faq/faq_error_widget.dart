import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class FaqErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const FaqErrorWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.red.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            const CommonTextWidget(
              text: 'Failed to Load FAQs',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
            const SizedBox(height: 12),
            CommonTextWidget(
              text: message,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppConstants.white.withOpacity(0.7),
              align: TextAlign.center,
              maxLines: 3,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Try Again',
                onPressed: onRetry!,
                backgroundColor: AppConstants.appPrimaryColor,
                textColor: AppConstants.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 48,
                width: 150,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
