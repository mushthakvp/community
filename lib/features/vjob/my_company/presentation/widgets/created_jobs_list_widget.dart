import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../domain/entities/created_job_entity.dart';
import '../providers/my_company_provider.dart';

class CreatedJobsListWidget extends StatelessWidget {
  final List<CreatedJobEntity> jobs;
  final CreatedJobsStatus status;
  final String errorMessage;
  final bool isLoadingMore;
  final VoidCallback onRetry;
  final Function(CreatedJobEntity) onJobTap;
  final Function(String) onReapply;
  final Function(String) onMarkClosed;

  const CreatedJobsListWidget({
    super.key,
    required this.jobs,
    required this.status,
    required this.errorMessage,
    required this.isLoadingMore,
    required this.onRetry,
    required this.onJobTap,
    required this.onReapply,
    required this.onMarkClosed,
  });

  @override
  Widget build(BuildContext context) {
    if (status == CreatedJobsStatus.loading) {
      return const Center(child: LoadingWidget(message: 'Loading jobs...'));
    }

    if (status == CreatedJobsStatus.error) {
      return _buildErrorView();
    }

    if (jobs.isEmpty && status == CreatedJobsStatus.loaded) {
      return _buildEmptyView();
    }

    return Column(
      children: [
        ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: jobs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final job = jobs[index];
            return _buildJobCard(job, context);
          },
        ),
        if (isLoadingMore) ...[
          const SizedBox(height: 16),
          const Center(child: LoadingWidget(size: 30, showMessage: false)),
        ],
      ],
    );
  }

  Widget _buildJobCard(CreatedJobEntity job, BuildContext context) {
    final timeAgo = timeago.format(job.createdAt);

    return GestureDetector(
      onTap: () => onJobTap(job),
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
            _buildJobHeader(job),
            const SizedBox(height: 12),
            _buildCompanyName(job),
            const SizedBox(height: 12),
            _buildJobDetails(job),
            const SizedBox(height: 12),
            _buildJobFooter(job, timeAgo),
            if (_shouldShowActions(job)) ...[
              const SizedBox(height: 16),
              _buildJobActions(job),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildJobHeader(CreatedJobEntity job) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              _buildCompanyImage(job),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget(
                      text: job.title,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.white,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    CommonTextWidget(
                      text: '${job.city}, ${job.state}',
                      fontSize: 14,
                      color: AppConstants.white.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildStatusBadge(job.status),
      ],
    );
  }

  Widget _buildCompanyImage(CreatedJobEntity job) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: job.company.image != null && job.company.image!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                job.company.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              ),
            )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Icon(
      Icons.business,
      size: 24,
      color: AppConstants.white.withOpacity(0.5),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor;
    switch (status) {
      case 'Accepted':
        statusColor = const Color(0xff44971C);
        break;
      case 'Requested':
        statusColor = const Color(0xff0D5FF9);
        break;
      case 'Rejected':
        statusColor = const Color(0xffD42B2B);
        break;
      default:
        statusColor = AppConstants.appPrimaryColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.5)),
      ),
      child: CommonTextWidget(
        text: status,
        fontSize: 12,
        color: statusColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildCompanyName(CreatedJobEntity job) {
    return CommonTextWidget(
      text: job.company.name,
      fontSize: 16,
      color: AppConstants.white.withOpacity(0.6),
      fontWeight: FontWeight.w400,
    );
  }

  Widget _buildJobDetails(CreatedJobEntity job) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: job.schedule
          .map((schedule) => _buildDetailChip(schedule))
          .toList(),
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

  Widget _buildJobFooter(CreatedJobEntity job, String timeAgo) {
    return Column(
      children: [
        Row(
          children: [
            _buildFooterItem(icon: Icons.access_time_outlined, text: timeAgo),
            const SizedBox(width: 16),
            _buildFooterItem(
              icon: Icons.people_outline,
              text: '${job.totalApply} applicants',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildFooterItem(
              icon: Icons.visibility_outlined,
              text: '${job.totalView} views',
            ),
            const Spacer(),
            _buildFooterItem(icon: Icons.money, text: '${job.minimumSalary}'),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterItem({required IconData icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppConstants.white.withOpacity(0.6)),
        const SizedBox(width: 4),
        CommonTextWidget(
          text: text,
          fontSize: 12,
          color: AppConstants.white.withOpacity(0.6),
        ),
      ],
    );
  }

  bool _shouldShowActions(CreatedJobEntity job) {
    return job.status == 'Rejected' || job.status == 'Accepted';
  }

  Widget _buildJobActions(CreatedJobEntity job) {
    return Row(
      children: [
        if (job.status == 'Rejected') ...[
          Expanded(
            child: _buildActionButton(
              text: 'Reapply',
              onPressed: () => onReapply(job.id),
              color: AppConstants.appPrimaryColor,
              icon: Icons.refresh,
            ),
          ),
        ],
        if (job.status == 'Accepted') ...[
          Expanded(
            child: _buildActionButton(
              text: 'Mark as Closed',
              onPressed: () => onMarkClosed(job.id),
              color: Colors.orange,
              icon: Icons.close,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
    required IconData icon,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: CommonTextWidget(
        text: text,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppConstants.black,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppConstants.black,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            CommonTextWidget(
              text: errorMessage,
              fontSize: 16,
              color: AppConstants.white.withOpacity(0.8),
              align: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.appPrimaryColor,
                foregroundColor: AppConstants.black,
              ),
              child: const CommonTextWidget(
                text: 'Retry',
                color: AppConstants.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.work_outline,
              size: 48,
              color: AppConstants.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            CommonTextWidget(
              text: 'No jobs found',
              fontSize: 16,
              color: AppConstants.white.withOpacity(0.7),
              align: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: 'You haven\'t posted any jobs yet.',
              fontSize: 14,
              color: AppConstants.white.withOpacity(0.5),
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
