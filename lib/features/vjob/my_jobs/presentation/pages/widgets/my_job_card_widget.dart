import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/my_job_entity.dart';

/// Reusable widget for displaying job cards in My Jobs
class MyJobCardWidget extends StatelessWidget {
  final MyJobEntity job;
  final VoidCallback onTap;
  final VoidCallback? onActionTap;
  final Widget? actionWidget;
  final bool showStatus;

  const MyJobCardWidget({
    super.key,
    required this.job,
    required this.onTap,
    this.onActionTap,
    this.actionWidget,
    this.showStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xff0F0F0F),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppConstants.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildCompanyName(),
            const SizedBox(height: 12),
            _buildJobDetails(),
            if (showStatus) ...[
              const SizedBox(height: 12),
              _buildStatusBadge(),
            ],
            const SizedBox(height: 12),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  /// Build the header with job title, location, and action
  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              _buildCompanyImage(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget(
                      text: job.jobDetails.title,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.white,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    CommonTextWidget(
                      text: job.jobDetails.location,
                      fontSize: 14,
                      color: AppConstants.white.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (actionWidget != null) ...[
          const SizedBox(width: 8),
          GestureDetector(onTap: onActionTap, child: actionWidget!),
        ],
      ],
    );
  }

  /// Build company image/avatar
  Widget _buildCompanyImage() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        image: job.jobDetails.company.image != null
            ? DecorationImage(
                image: NetworkImage(job.jobDetails.company.image!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: job.jobDetails.company.image == null
          ? Icon(
              Icons.business,
              color: AppConstants.white.withOpacity(0.5),
              size: 24,
            )
          : null,
    );
  }

  Widget _buildCompanyName() {
    return CommonTextWidget(
      text: job.jobDetails.company.name,
      fontSize: 16,
      color: AppConstants.white.withOpacity(0.6),
      fontWeight: FontWeight.w400,
    );
  }

  Widget _buildJobDetails() {
    final details = <String>[
      ...job.jobDetails.schedule.take(2),
      job.jobDetails.workStyle,
    ].where((detail) => detail.isNotEmpty).toList();

    if (details.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: details.map((detail) => _buildDetailChip(detail)).toList(),
    );
  }

  Widget _buildDetailChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppConstants.appPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.appPrimaryColor.withOpacity(0.3),
        ),
      ),
      child: CommonTextWidget(
        text: text,
        fontSize: 12,
        color: AppConstants.appPrimaryColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color statusColor;
    String statusText;

    if (job.jobDetails.isAccepted) {
      statusColor = Colors.green;
      statusText = 'Accepted';
    } else if (job.jobDetails.isRejected) {
      statusColor = Colors.red;
      statusText = 'Rejected';
    } else {
      statusColor = Colors.orange;
      statusText = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: CommonTextWidget(
        text: statusText,
        fontSize: 12,
        color: statusColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildFooter() {
    final timeAgo = timeago.format(job.createdAt);

    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildFooterItem(icon: Icons.access_time, text: timeAgo),
              _buildFooterItem(
                icon: Icons.attach_money,
                text: job.jobDetails.salaryFormatted,
              ),
              if (job.jobDetails.rejectCount > 0)
                _buildFooterItem(
                  icon: Icons.refresh,
                  text: '${job.jobDetails.reAppliedCount} reapplied',
                  color: Colors.orange,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterItem({
    required IconData icon,
    required String text,
    Color? color,
  }) {
    final itemColor = color ?? AppConstants.white.withOpacity(0.6);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: itemColor),
        const SizedBox(width: 4),
        CommonTextWidget(text: text, fontSize: 12, color: itemColor),
      ],
    );
  }
}

class AppliedJobCardWidget extends StatelessWidget {
  final MyJobEntity job;
  final VoidCallback onTap;

  const AppliedJobCardWidget({
    super.key,
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MyJobCardWidget(job: job, onTap: onTap, showStatus: true);
  }
}

class SavedJobCardWidget extends StatelessWidget {
  final MyJobEntity job;
  final VoidCallback onTap;
  final VoidCallback onUnsave;

  const SavedJobCardWidget({
    super.key,
    required this.job,
    required this.onTap,
    required this.onUnsave,
  });

  @override
  Widget build(BuildContext context) {
    return MyJobCardWidget(
      job: job,
      onTap: onTap,
      onActionTap: onUnsave,
      actionWidget: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          Icons.bookmark,
          color: AppConstants.appPrimaryColor,
          size: 24,
        ),
      ),
    );
  }
}
