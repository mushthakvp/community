import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/job_details_entity.dart';

class JobHeaderWidget extends StatelessWidget {
  final JobDetailsEntity jobDetails;

  const JobHeaderWidget({super.key, required this.jobDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildJobNameAndImage(),
          const SizedBox(height: 16),
          _buildJobSchedule(),
          const SizedBox(height: 8),
          _buildJobStats(),
        ],
      ),
    );
  }

  Widget _buildJobNameAndImage() {
    return Row(
      children: [
        _buildCompanyImage(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextWidget(
                text: jobDetails.title,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              CommonTextWidget(
                text: '${jobDetails.city}, ${jobDetails.state}',
                fontSize: 14,
                color: AppConstants.white.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyImage() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        image: jobDetails.company.image != null
            ? DecorationImage(
                image: NetworkImage(jobDetails.company.image!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: jobDetails.company.image == null
          ? Icon(
              Icons.business,
              color: AppConstants.white.withOpacity(0.5),
              size: 30,
            )
          : null,
    );
  }

  Widget _buildJobSchedule() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: jobDetails.schedule
          .map((schedule) => _buildScheduleChip(schedule))
          .toList(),
    );
  }

  Widget _buildScheduleChip(String text) {
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

  Widget _buildJobStats() {
    final timeAgo = timeago.format(jobDetails.createdAt);

    return Row(
      children: [
        _buildStatItem(icon: Icons.access_time, text: timeAgo),
        const SizedBox(width: 16),
        _buildStatItem(
          icon: Icons.people_outline,
          text: '${jobDetails.totalApplication} applicants',
        ),
        const SizedBox(width: 16),
        _buildStatItem(
          icon: Icons.attach_money,
          text: '\${jobDetails.minimumSalary}',
        ),
      ],
    );
  }

  Widget _buildStatItem({required IconData icon, required String text}) {
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
}
