import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/job_details_entity.dart';

class JobDetailsTabWidget extends StatelessWidget {
  final JobDetailsEntity jobDetails;

  const JobDetailsTabWidget({super.key, required this.jobDetails});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: 'Company Overview',
            content: jobDetails.company.description,
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: 'About the Role',
            content: jobDetails.description,
          ),
          const SizedBox(height: 20),
          _buildResponsibilitiesSection(),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          text: title,
          color: AppConstants.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 12),
        CommonTextWidget(
          text: content,
          color: AppConstants.white.withOpacity(0.6),
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
      ],
    );
  }

  Widget _buildResponsibilitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextWidget(
          text: 'Responsibilities',
          color: AppConstants.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 12),
        ...jobDetails.responsibilities.map(
          (responsibility) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildBulletPoint(responsibility),
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: AppConstants.white,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CommonTextWidget(
            text: text,
            color: AppConstants.white.withOpacity(0.6),
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
