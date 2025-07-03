import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class ProfileStatsWidget extends StatelessWidget {
  final int activeAdsCount;
  final int renewAdsCount;
  final int jobsCount;
  final int chatToAnswer;

  const ProfileStatsWidget({
    super.key,
    required this.activeAdsCount,
    required this.renewAdsCount,
    required this.jobsCount,
    required this.chatToAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.chat_bubble_outline,
                  title: 'Chat to answer',
                  count: chatToAnswer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Active listings',
                  count: activeAdsCount,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.refresh,
                  title: 'List to renew',
                  count: renewAdsCount,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.work_outline,
                  title: 'Jobs',
                  count: jobsCount,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required int count,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppConstants.appPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppConstants.black, size: 20),
              ),
              CommonTextWidget(
                text: count.toString(),
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
              ),
            ],
          ),
          const SizedBox(height: 8),
          CommonTextWidget(
            text: title,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppConstants.white.withOpacity(0.8),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
