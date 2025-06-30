import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class FormSectionWidget extends StatelessWidget {
  final String title;
  final Widget child;
  final String? subtitle;

  const FormSectionWidget({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          text: title,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          CommonTextWidget(
            text: subtitle!,
            fontSize: 12,
            color: AppConstants.white.withOpacity(0.6),
          ),
        ],
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
