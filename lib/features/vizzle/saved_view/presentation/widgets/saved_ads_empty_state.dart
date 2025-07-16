import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class SavedAdsEmptyState extends StatelessWidget {
  const SavedAdsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppConstants.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.favorite_border_outlined,
              size: 60,
              color: AppConstants.white.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 24),
          const CommonTextWidget(
            text: 'No Saved Ads',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppConstants.white,
          ),
          const SizedBox(height: 8),
          CommonTextWidget(
            text:
                'Start saving ads you love by tapping\nthe heart icon on any listing',
            fontSize: 14,
            color: AppConstants.white.withOpacity(0.6),
            align: TextAlign.center,
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to vizzle home or ads listing
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.search, size: 18),
            label: const Text('Browse Ads'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.appPrimaryColor,
              foregroundColor: AppConstants.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
