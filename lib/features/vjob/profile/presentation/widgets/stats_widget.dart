import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class StatsWidget extends StatelessWidget {
  final int totalApplied;
  final int totalPosted;

  const StatsWidget({
    super.key,
    required this.totalApplied,
    required this.totalPosted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xff161616).withOpacity(0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            color: AppConstants.appPrimaryColor,
            count: totalApplied,
            label: 'Applied Jobs',
          ),
          Container(
            height: 80,
            width: 2,
            color: AppConstants.white.withOpacity(0.1),
          ),
          _buildStatItem(
            color: const Color(0xff2A94F4),
            count: totalPosted,
            label: 'Posted Jobs',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required Color color,
    required int count,
    required String label,
  }) {
    return Column(
      children: [
        CircleAvatar(radius: 10, backgroundColor: color),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: count.toString(),
          color: AppConstants.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 4),
        CommonTextWidget(
          text: label,
          color: AppConstants.white.withOpacity(0.6),
          fontSize: 12,
          fontWeight: FontWeight.w300,
          align: TextAlign.center,
        ),
      ],
    );
  }
}
