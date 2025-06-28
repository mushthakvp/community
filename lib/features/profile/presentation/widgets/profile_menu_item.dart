import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDivider;
  final Color? iconColor;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showDivider = true,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (iconColor ?? AppConstants.appPrimaryColor).withOpacity(
                0.1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppConstants.appPrimaryColor,
              size: 24,
            ),
          ),
          title: CommonTextWidget(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppConstants.white,
          ),
          subtitle: CommonTextWidget(
            text: subtitle,
            fontSize: 14,
            color: AppConstants.white.withOpacity(0.7),
            maxLines: 2,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppConstants.white.withOpacity(0.5),
            size: 16,
          ),
        ),
        if (showDivider)
          Container(
            margin: const EdgeInsets.only(left: 72),
            height: 1,
            color: AppConstants.white.withOpacity(0.1),
          ),
      ],
    );
  }
}
