// lib/features/coupons/presentation/widgets/error_widget.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common_button.dart';
import '../../../../core/widgets/common_text_widget.dart';

class CouponErrorWidget extends StatelessWidget {
  final String message;
  final bool canRetry;
  final VoidCallback? onRetry;

  const CouponErrorWidget({
    super.key,
    required this.message,
    required this.canRetry,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            CommonTextWidget(
              text: 'Oops! Something went wrong',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: message,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppConstants.white.withOpacity(0.8),
              align: TextAlign.center,
              maxLines: 3,
            ),
            if (canRetry && onRetry != null) ...[
              const SizedBox(height: 24),
              CommonButton(
                text: 'Try Again',
                onTap: onRetry!,
                bgColor: AppConstants.appPrimaryColor,
                borderColor: AppConstants.appPrimaryColor,
                textColor: AppConstants.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                borderRadius: BorderRadius.circular(12),
                height: 48,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
