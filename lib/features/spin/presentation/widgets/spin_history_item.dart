import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/spin_history_entity.dart';

class SpinHistoryItem extends StatelessWidget {
  final SpinHistoryEntity history;
  final VoidCallback? onTap;

  const SpinHistoryItem({super.key, required this.history, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonTextWidget(
                  text: history.formattedDate,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.appPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CommonTextWidget(
                    text:
                        '${history.totalSpins} ${history.totalSpins == 1 ? 'Spin' : 'Spins'}',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.appPrimaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Stats
            Row(
              children: [
                _buildStatItem(
                  icon: Icons.stars,
                  color: Colors.amber,
                  label: 'Points',
                  value: '${history.loyaltyPointsEarned}',
                ),

                const SizedBox(width: 16),

                _buildStatItem(
                  icon: Icons.local_offer,
                  color: Colors.green,
                  label: 'Coupons',
                  value: '${history.couponsEarned.length}',
                ),

                const SizedBox(width: 16),

                _buildStatItem(
                  icon: Icons.percent,
                  color: Colors.blue,
                  label: 'Win Rate',
                  value: '${history.winningPercentage.toStringAsFixed(0)}%',
                ),
              ],
            ),

            // Recent results preview
            if (history.results.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildRecentResults(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextWidget(
              text: value,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            CommonTextWidget(
              text: label,
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentResults() {
    final recentResults = history.results.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          text: 'Recent Results:',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
        const SizedBox(height: 4),

        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: recentResults.map((result) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: result.isWinning
                    ? Colors.green.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    result.spinOption.rewardIcon,
                    size: 12,
                    color: result.spinOption.rewardColor,
                  ),
                  const SizedBox(width: 4),
                  CommonTextWidget(
                    text: result.spinOption.rewardDisplayText,
                    fontSize: 10,
                    color: Colors.grey.shade700,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
