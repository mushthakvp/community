import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/idea_entity.dart';

class IdeaCard extends StatelessWidget {
  final IdeaEntity idea;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const IdeaCard({
    super.key,
    required this.idea,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConstants.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppConstants.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CommonTextWidget(
                    text: idea.projectName,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.white,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    _buildStatusBadge(idea.currentStatus),
                    if (onDelete != null) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onDelete,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Founders section
            Row(
              children: [
                _buildFoundersAvatars(),
                const SizedBox(width: 8),
                CommonTextWidget(
                  text:
                      '${idea.founders.length} Founder${idea.founders.length > 1 ? 's' : ''}',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppConstants.white.withOpacity(0.7),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Summary
            CommonTextWidget(
              text: idea.summaryOfIdea,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppConstants.white.withOpacity(0.8),
              maxLines: 2,
            ),

            const SizedBox(height: 12),

            // Footer with date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonTextWidget(
                  text: 'Created: ${_formatDate(idea.createdAt)}',
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppConstants.white.withOpacity(0.6),
                ),
                if (idea.isRejected && idea.rejectCount > 0)
                  CommonTextWidget(
                    text:
                        'Rejected ${idea.rejectCount} time${idea.rejectCount > 1 ? 's' : ''}',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.red.withOpacity(0.8),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'accepted':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'rejected':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      case 'requested':
      default:
        color = Colors.blue;
        icon = Icons.pending;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          CommonTextWidget(
            text: status,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildFoundersAvatars() {
    return SizedBox(
      width: idea.founders.length > 3 ? 80 : idea.founders.length * 24.0,
      height: 24,
      child: Stack(
        children: idea.founders.take(3).map((founder) {
          final index = idea.founders.indexOf(founder);
          return Positioned(
            left: index * 16.0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppConstants.black, width: 2),
              ),
              child: Center(
                child: CommonTextWidget(
                  text: founder.name.isNotEmpty
                      ? founder.name[0].toUpperCase()
                      : '?',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.black,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
}
