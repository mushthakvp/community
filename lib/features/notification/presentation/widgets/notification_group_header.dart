import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';

class NotificationGroupHeader extends StatelessWidget {
  final String title;

  const NotificationGroupHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: AppConstants.appPrimaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CommonTextWidget(
              text: _getDisplayTitle(title),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
          ),
          _buildDateIcon(),
        ],
      ),
    );
  }

  String _getDisplayTitle(String title) {
    if (title == 'Today') {
      return 'Today';
    } else if (title == 'Yesterday') {
      return 'Yesterday';
    } else {
      // Format date string to more readable format
      try {
        final parts = title.split('-');
        if (parts.length == 3) {
          final year = parts[0];
          final month = parts[1];
          final day = parts[2];

          final monthNames = [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ];

          final monthIndex = int.parse(month) - 1;
          final monthName = monthIndex < monthNames.length
              ? monthNames[monthIndex]
              : month;

          return '$day $monthName $year';
        }
      } catch (e) {
        // If parsing fails, return original title
      }
      return title;
    }
  }

  Widget _buildDateIcon() {
    IconData icon;
    Color color;

    switch (title) {
      case 'Today':
        icon = Icons.today;
        color = AppConstants.appPrimaryColor;
        break;
      case 'Yesterday':
        icon = Icons.history;
        color = Colors.orange;
        break;
      default:
        icon = Icons.calendar_today;
        color = AppConstants.white.withOpacity(0.6);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }
}
