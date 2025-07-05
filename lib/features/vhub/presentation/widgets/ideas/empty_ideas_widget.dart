import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class EmptyIdeasWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRefresh;

  const EmptyIdeasWidget({super.key, required this.message, this.onRefresh});

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
                color: AppConstants.appPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.lightbulb_outline,
                size: 40,
                color: AppConstants.appPrimaryColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            const CommonTextWidget(
              text: 'No Ideas Found',
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
