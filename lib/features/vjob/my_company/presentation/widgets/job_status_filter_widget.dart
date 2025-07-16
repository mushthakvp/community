import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class JobStatusFilterWidget extends StatelessWidget {
  final String selectedStatus;
  final List<String> statusList;
  final Function(String) onStatusChanged;

  const JobStatusFilterWidget({
    super.key,
    required this.selectedStatus,
    required this.statusList,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onStatusChanged,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xff1a1a1a),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _getStatusColor(selectedStatus).withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getStatusColor(selectedStatus).withOpacity(0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonTextWidget(
              text: selectedStatus,
              fontSize: 14,
              color: _getStatusColor(selectedStatus),
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: _getStatusColor(selectedStatus),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => statusList.map((status) {
        final isSelected = status == selectedStatus;
        return PopupMenuItem<String>(
          value: status,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                CommonTextWidget(
                  text: status,
                  fontSize: 14,
                  color: isSelected
                      ? _getStatusColor(status)
                      : AppConstants.white.withOpacity(0.8),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'All':
        return const Color(0xff00989E);
      case 'Accepted':
        return const Color(0xff44971C);
      case 'Requested':
        return const Color(0xff0D5FF9);
      case 'Rejected':
        return const Color(0xffD42B2B);
      default:
        return AppConstants.appPrimaryColor;
    }
  }
}
