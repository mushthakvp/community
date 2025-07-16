import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class VHubStatsSection extends StatelessWidget {
  const VHubStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppConstants.appPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppConstants.appPrimaryColor.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: 'Our Impact',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppConstants.appPrimaryColor,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    title: '170+',
                    subtitle: 'Spin-outs',
                    icon: Icons.business_outlined,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    title: '10+',
                    subtitle: 'Start-ups',
                    icon: Icons.rocket_launch_outlined,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    title: '30+',
                    subtitle: 'Countries',
                    icon: Icons.public_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppConstants.appPrimaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: AppConstants.appPrimaryColor),
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: title,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppConstants.white,
        ),
        const SizedBox(height: 4),
        CommonTextWidget(
          text: subtitle,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.7),
          align: TextAlign.center,
        ),
      ],
    );
  }
}
