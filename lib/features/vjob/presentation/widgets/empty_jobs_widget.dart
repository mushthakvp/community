import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/text_widget.dart';

class EmptyJobsWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRefresh;

  const EmptyJobsWidget({super.key, required this.message, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.work_outline,
                size: 56,
                color: AppConstants.appPrimaryColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            const CommonTextWidget(
              text: 'No Jobs Found',
              fontSize: 20,
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
              maxLines: 2,
            ),
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
