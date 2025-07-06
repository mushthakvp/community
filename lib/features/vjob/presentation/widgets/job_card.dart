import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/job_entity.dart';

class JobCard extends StatelessWidget {
  final JobEntity job;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final VoidCallback? onApply;

  const JobCard({
    super.key,
    required this.job,
    this.onTap,
    this.onSave,
    this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          border: Border.all(color: AppConstants.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildJobInfo(),
            const SizedBox(height: 12),
            _buildJobDetails(),
            const SizedBox(height: 16),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildCompanyLogo(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextWidget(
                text: job.title,
                color: AppConstants.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              CommonTextWidget(
                text: job.company.name,
                color: AppConstants.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
        if (onSave != null)
          GestureDetector(
            onTap: onSave,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: job.isSaved
                    ? AppConstants.appPrimaryColor.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: job.isSaved
                      ? AppConstants.appPrimaryColor
                      : AppConstants.white.withOpacity(0.3),
                ),
              ),
              child: Icon(
                job.isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: job.isSaved
                    ? AppConstants.appPrimaryColor
                    : AppConstants.white.withOpacity(0.7),
                size: 20,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCompanyLogo() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: job.company.image?.isNotEmpty ?? false
            ? CachedNetworkImage(
                imageUrl: job.company.image!,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildPlaceholderLogo(),
                errorWidget: (context, url, error) => _buildPlaceholderLogo(),
              )
            : _buildPlaceholderLogo(),
      ),
    );
  }

  Widget _buildPlaceholderLogo() {
    return Container(
      color: AppConstants.appPrimaryColor.withOpacity(0.2),
      child: Center(
        child: CommonTextWidget(
          text: job.company.name.isNotEmpty
              ? job.company.name[0].toUpperCase()
              : '?',
          color: AppConstants.appPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildJobInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: AppConstants.white.withOpacity(0.6),
              size: 16,
            ),
            const SizedBox(width: 4),
            CommonTextWidget(
              text: job.location,
              color: AppConstants.white.withOpacity(0.6),
              fontSize: 12,
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.work_outline,
              color: AppConstants.white.withOpacity(0.6),
              size: 16,
            ),
            const SizedBox(width: 4),
            CommonTextWidget(
              text: job.workStyle,
              color: AppConstants.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ],
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: job.formattedSalary,
          color: AppConstants.appPrimaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget _buildJobDetails() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        ...job.schedule.take(3).map((schedule) => _buildTag(schedule)),
        if (job.schedule.length > 3)
          _buildTag('+${job.schedule.length - 3} more'),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CommonTextWidget(
        text: text,
        color: AppConstants.white.withOpacity(0.8),
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CommonTextWidget(
              text: job.createdAt.timeAgo(),
              color: AppConstants.white.withOpacity(0.5),
              fontSize: 11,
            ),
            const SizedBox(width: 12),
            CommonTextWidget(
              text: '${job.totalApplications} applicants',
              color: AppConstants.white.withOpacity(0.5),
              fontSize: 11,
            ),
          ],
        ),
        if (onApply != null)
          GestureDetector(
            onTap: onApply,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const CommonTextWidget(
                text: 'Apply Now',
                color: AppConstants.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
