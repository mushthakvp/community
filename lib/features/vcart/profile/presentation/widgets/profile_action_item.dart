import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';

class ProfileActionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const ProfileActionItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? VCartColors.textPrimary;
    final effectiveTextColor = textColor ?? VCartColors.textPrimary;

    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: effectiveIconColor, size: 24),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: effectiveTextColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: effectiveIconColor, size: 24),
      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
    );
  }
}
