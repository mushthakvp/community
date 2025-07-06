import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/job_entity.dart';

class JobCard extends StatelessWidget {
  final JobEntity job;
  final VoidCallback onSave;
  final Function(String resume) onApply;

  const JobCard({
    super.key,
    required this.job,
    required this.onSave,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildJobDetails(),
          const SizedBox(height: 12),
          _buildTags(),
          const SizedBox(height: 16),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppConstants.white.withOpacity(0.1)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: job.company.image,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: const Color(0xFF2A2A2A),
                child: const Icon(
                  Icons.business,
                  color: AppConstants.white,
                  size: 24,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: const Color(0xFF2A2A2A),
                child: const Icon(
                  Icons.business,
                  color: AppConstants.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
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
                text: '${job.city}, ${job.state}',
                color: AppConstants.white.withOpacity(0.6),
                fontSize: 14,
                maxLines: 1,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onSave,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: job.isSaved == true
                  ? AppConstants.appPrimaryColor.withOpacity(0.2)
                  : AppConstants.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              job.isSaved == true ? Icons.bookmark : Icons.bookmark_border,
              color: job.isSaved == true
                  ? AppConstants.appPrimaryColor
                  : AppConstants.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJobDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          text: job.company.name,
          color: AppConstants.white.withOpacity(0.8),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: job.description,
          color: AppConstants.white.withOpacity(0.7),
          fontSize: 13,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
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
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(6),
      ),
      child: CommonTextWidget(
        text: text,
        color: AppConstants.white,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildFooter() {
    final timeAgo = timeago.format(job.createdAt);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CommonTextWidget(
                    text: timeAgo,
                    color: AppConstants.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppConstants.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CommonTextWidget(
                    text: '${job.totalApplication} Applicants',
                    color: AppConstants.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              CommonTextWidget(
                text: '\${job.minimumSalary}/M',
                color: AppConstants.appPrimaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 100,
          height: 36,
          child: PrimaryButton(
            text: 'Apply',
            onPressed: () => _showApplyDialog(),
            backgroundColor: AppConstants.appPrimaryColor,
            textColor: AppConstants.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showApplyDialog() {
    // This would show a dialog to upload resume
    // For now, we'll just call onApply with a dummy resume
    onApply('dummy_resume_url');
  }
}
