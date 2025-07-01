import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class AdsEmptyState extends StatelessWidget {
  final bool hasActiveFilters;
  final VoidCallback onClearFilters;

  const AdsEmptyState({
    super.key,
    required this.hasActiveFilters,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasActiveFilters ? Icons.search_off : Icons.inventory_2_outlined,
              size: 80,
              color: AppConstants.white.withOpacity(0.3),
            ),

            const SizedBox(height: 24),

            CommonTextWidget(
              text: hasActiveFilters
                  ? 'No ads match your filters'
                  : 'No ads found',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
              align: TextAlign.center,
            ),

            const SizedBox(height: 12),

            CommonTextWidget(
              text: hasActiveFilters
                  ? 'Try adjusting your search criteria or clear filters to see more results.'
                  : 'There are no ads available at the moment. Please check back later.',
              fontSize: 14,
              color: AppConstants.white.withOpacity(0.7),
              align: TextAlign.center,
            ),

            if (hasActiveFilters) ...[
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Clear Filters',
                onPressed: onClearFilters,
                backgroundColor: AppConstants.appPrimaryColor,
                textColor: AppConstants.black,
                width: 150,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
