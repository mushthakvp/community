import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class VHubFeaturesGrid extends StatelessWidget {
  const VHubFeaturesGrid({super.key});

  final List<FeatureItem> _features = const [
    FeatureItem(
      title: 'Business Incubation',
      description: 'Comprehensive support program for business development',
      icon: Icons.incomplete_circle,
      color: Colors.orange,
    ),
    FeatureItem(
      title: 'Mentoring',
      description: 'Expert guidance from experienced entrepreneurs',
      icon: Icons.people_outline,
      color: Colors.blue,
    ),
    FeatureItem(
      title: 'Funding Support',
      description: 'Access to investors and funding opportunities',
      icon: Icons.attach_money_outlined,
      color: Colors.green,
    ),
    FeatureItem(
      title: 'Networking',
      description: 'Connect with like-minded entrepreneurs',
      icon: Icons.network_cell_outlined,
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonTextWidget(
            text: 'What We Offer',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppConstants.appPrimaryColor,
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: _features.length,
            itemBuilder: (context, index) {
              final feature = _features[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppConstants.white.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: feature.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(feature.icon, size: 24, color: feature.color),
                    ),
                    const SizedBox(height: 12),
                    CommonTextWidget(
                      text: feature.title,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.white,
                      align: TextAlign.center,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    CommonTextWidget(
                      text: feature.description,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppConstants.white.withOpacity(0.7),
                      align: TextAlign.center,
                      maxLines: 3,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FeatureItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const FeatureItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
