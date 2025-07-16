import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/job_details_entity.dart';

class ProfileInsightsTabWidget extends StatelessWidget {
  final JobDetailsEntity jobDetails;

  const ProfileInsightsTabWidget({super.key, required this.jobDetails});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection(
          title: 'Skills',
          icon: Icons.psychology,
          items: jobDetails.skills,
        ),
        const SizedBox(height: 24),
        _buildSection(
          title: 'Education',
          icon: Icons.school,
          items: [jobDetails.education],
        ),
        const SizedBox(height: 24),
        _buildSection(
          title: 'Benefits',
          icon: Icons.card_giftcard,
          items: jobDetails.benefits,
        ),
        const SizedBox(height: 24),
        _buildSection(
          title: 'Languages',
          icon: Icons.language,
          items: jobDetails.languages,
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<String> items,
  }) {
    if (items.isEmpty || (items.length == 1 && items.first.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppConstants.appPrimaryColor, size: 20),
            const SizedBox(width: 8),
            CommonTextWidget(
              text: title,
              color: AppConstants.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) => _buildChip(item)).toList(),
        ),
      ],
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppConstants.appPrimaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check,
            color: AppConstants.appPrimaryColor,
            size: 16,
          ),
          const SizedBox(width: 6),
          CommonTextWidget(text: text, color: AppConstants.white, fontSize: 14),
        ],
      ),
    );
  }
}
