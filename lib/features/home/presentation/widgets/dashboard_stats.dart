import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';

class DashboardStats extends StatelessWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: const CommonTextWidget(
        text: 'Dashboard Stats - Coming Soon',
        fontSize: 16,
        color: AppConstants.white,
        align: TextAlign.center,
      ),
    );
  }
}
