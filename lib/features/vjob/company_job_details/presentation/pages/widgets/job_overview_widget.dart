import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/company_job_entity.dart';

class JobOverviewWidget extends StatelessWidget {
  final CompanyJobEntity job;

  const JobOverviewWidget({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Job Overview'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                icon: Icons.visibility,
                title: 'Views',
                count: job.totalView.toString(),
                backgroundColor: const Color(0xffB8E48F),
                iconColor: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                icon: Icons.person_add,
                title: 'Applied',
                count: job.totalApplication.toString(),
                backgroundColor: const Color(0xffFF9483),
                iconColor: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                icon: Icons.bookmark,
                title: 'Saved',
                count: job.totalSave.toString(),
                backgroundColor: const Color(0xffF7A928),
                iconColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return CommonTextWidget(
      text: title,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppConstants.white,
    );
  }

  Widget _buildOverviewCard({
    required IconData icon,
    required String title,
    required String count,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff161616),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          CommonTextWidget(
            text: count,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppConstants.white,
          ),
          const SizedBox(height: 4),
          CommonTextWidget(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppConstants.white.withOpacity(0.7),
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
