// lib/features/coupons/presentation/widgets/empty_state_widget.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common_button.dart';
import '../../../../core/widgets/common_text_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRefresh;

  const EmptyStateWidget({super.key, required this.message, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: AppConstants.white.withOpacity(0.4),
            ),
            const SizedBox(height: 24),
            CommonTextWidget(
              text: 'No Coupons Found',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: message,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppConstants.white.withOpacity(0.7),
              align: TextAlign.center,
              maxLines: 2,
            ),
            if (onRefresh != null) ...[
              const SizedBox(height: 24),
              CommonButton(
                text: 'Refresh',
                onTap: onRefresh!,
                bgColor: Colors.transparent,
                borderColor: AppConstants.appPrimaryColor,
                textColor: AppConstants.appPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
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
