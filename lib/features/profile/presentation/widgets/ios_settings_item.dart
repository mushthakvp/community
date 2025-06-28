import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';

class IOSSettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;
  final Color? backgroundColor;

  const IOSSettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
    this.iconColor,
    this.titleColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppConstants.appPrimaryColor)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: iconColor ?? AppConstants.appPrimaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget(
                      text: title,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: titleColor ?? AppConstants.white,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      CommonTextWidget(
                        text: subtitle!,
                        fontSize: 13,
                        color: const Color(0xFF8E8E93),
                        maxLines: 2,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (trailing != null) ...[trailing!, const SizedBox(width: 8)],
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: Color(0xFF8E8E93),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
