import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/home_job_entity.dart';

class JobCardWidget extends StatelessWidget {
  final HomeJobEntity job;
  final VoidCallback onTap;
  final VoidCallback onSave;
  final VoidCallback onApply;

  const JobCardWidget({
    super.key,
    required this.job,
    required this.onTap,
    required this.onSave,
    required this.onApply,
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
            const SizedBox(height: 12),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildCompanyImage() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        image: job.company.image != null
            ? DecorationImage(
                image: NetworkImage(job.company.image!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: job.company.image == null
          ? Icon(
              Icons.business,
              color: AppConstants.white.withOpacity(0.5),
              size: 24,
            )
          : null,
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: onSave,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          job.isSaved ? Icons.bookmark : Icons.bookmark_border,
          color: job.isSaved
              ? AppConstants.appPrimaryColor
              : AppConstants.white.withOpacity(0.7),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildCompanyName() {
    return CommonTextWidget(
      text: job.company.name,
      fontSize: 16,
      color: AppConstants.white.withOpacity(0.6),
      fontWeight: FontWeight.w400,
    );
  }

  Widget _buildJobDetails() {
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

  Widget _buildFooter() {
    final timeAgo = timeago.format(job.createdAt);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              _buildFooterItem(icon: Icons.access_time, text: timeAgo),
              const SizedBox(width: 16),
              _buildFooterItem(
                icon: Icons.people_outline,
                text: '${job.totalApplication} applicants',
              ),
              const SizedBox(width: 16),
              _buildFooterItem(
                icon: Icons.attach_money,
                text: '\${job.minimumSalary}',
              ),
            ],
          ),
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
}
