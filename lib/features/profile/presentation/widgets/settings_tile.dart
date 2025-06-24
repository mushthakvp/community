import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDivider;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Icon(icon, color: AppConstants.appPrimaryColor, size: 24),
          title: CommonTextWidget(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppConstants.white,
          ),
          subtitle: CommonTextWidget(
            text: subtitle,
            fontSize: 14,
            color: AppConstants.white.withOpacity(0.7),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: AppConstants.white,
            size: 16,
          ),
        ),
        if (showDivider)
          Divider(
            color: AppConstants.white.withOpacity(0.1),
            height: 1,
            indent: 56,
          ),
      ],
    );
  }
}
