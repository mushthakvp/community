import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/idea_entity.dart';

class IdeaCard extends StatelessWidget {
  final IdeaEntity idea;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const IdeaCard({
    super.key,
    required this.idea,
    required this.onTap,
    this.onDelete,
    this.onEdit,
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
          border: Border.all(
            color: idea.isRejected
                ? Colors.red.withOpacity(0.3)
                : AppConstants.white.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and actions
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
                    if (idea.isRejected && onEdit != null) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onEdit,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppConstants.appPrimaryColor.withOpacity(
                              0.2,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: AppConstants.appPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                    if (onDelete != null &&
                        (idea.isRequested || idea.isRejected)) ...[
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

            // Rejection reason (if rejected)
            if (idea.isRejected && idea.rejectReason != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        const CommonTextWidget(
                          text: 'Rejection Reason:',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    CommonTextWidget(
                      text: idea.rejectReason!,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppConstants.white.withOpacity(0.9),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

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

            // Footer with date and stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonTextWidget(
                  text: 'Created: ${_formatDate(idea.createdAt)}',
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppConstants.white.withOpacity(0.6),
                ),
                Row(
                  children: [
                    if (idea.isRejected && idea.rejectCount > 0) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CommonTextWidget(
                          text: 'Rejected ${idea.rejectCount}x',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (idea.reApplyCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CommonTextWidget(
                          text: 'Reapplied ${idea.reApplyCount}x',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                  ],
                ),
              ],
            ),

            // Action buttons for rejected ideas
            if (idea.isRejected) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: AppConstants.appPrimaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppConstants.appPrimaryColor.withOpacity(
                              0.5,
                            ),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              size: 16,
                              color: AppConstants.appPrimaryColor,
                            ),
                            SizedBox(width: 6),
                            CommonTextWidget(
                              text: 'Edit & Resubmit',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.appPrimaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppConstants.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppConstants.white.withOpacity(0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.visibility,
                        size: 16,
                        color: AppConstants.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
