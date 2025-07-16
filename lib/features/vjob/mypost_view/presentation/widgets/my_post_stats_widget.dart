import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/my_post_entity.dart';

class MyPostStatsWidget extends StatelessWidget {
  final PostStatsEntity stats;
  final VoidCallback? onTap;

  const MyPostStatsWidget({super.key, required this.stats, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xff0F0F0F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppConstants.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: 'Post Statistics',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.post_add,
                    label: 'Posts',
                    value: stats.totalPosts.toString(),
                    color: AppConstants.appPrimaryColor,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.favorite,
                    label: 'Likes',
                    value: stats.totalLikes.toString(),
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.visibility,
                    label: 'Views',
                    value: stats.totalViews.toString(),
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.comment,
                    label: 'Comments',
                    value: stats.totalComments.toString(),
                    color: Colors.green,
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
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: value,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppConstants.white,
        ),
        const SizedBox(height: 2),
        CommonTextWidget(
          text: label,
          fontSize: 12,
          color: AppConstants.white.withOpacity(0.7),
        ),
      ],
    );
  }
}
