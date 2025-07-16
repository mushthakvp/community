import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class DraftIndicatorWidget extends StatelessWidget {
  final bool hasDraft;
  final VoidCallback? onLoadDraft;
  final VoidCallback? onClearDraft;

  const DraftIndicatorWidget({
    super.key,
    this.hasDraft = false,
    this.onLoadDraft,
    this.onClearDraft,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasDraft) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.appPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppConstants.appPrimaryColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.drafts,
            color: AppConstants.appPrimaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: CommonTextWidget(
              text: 'Draft saved',
              fontSize: 14,
              color: AppConstants.appPrimaryColor,
            ),
          ),
          if (onLoadDraft != null)
            TextButton(
              onPressed: onLoadDraft,
              style: TextButton.styleFrom(
                foregroundColor: AppConstants.appPrimaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const CommonTextWidget(
                text: 'Load',
                fontSize: 12,
                color: AppConstants.appPrimaryColor,
              ),
            ),
          if (onClearDraft != null)
            IconButton(
              onPressed: onClearDraft,
              icon: const Icon(
                Icons.close,
                color: AppConstants.appPrimaryColor,
                size: 18,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
