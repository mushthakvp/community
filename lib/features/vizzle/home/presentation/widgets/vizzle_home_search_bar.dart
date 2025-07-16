import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class VizzleHomeSearchBar extends StatelessWidget {
  const VizzleHomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search Bar
        Expanded(
          child: GestureDetector(
            onTap: () => context.push(RouteConstants.vizzleSearch),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppConstants.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(
                    Icons.search,
                    color: AppConstants.white.withOpacity(0.6),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  CommonTextWidget(
                    text: 'Search Products',
                    color: AppConstants.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Filter Button
        GestureDetector(
          onTap: () {
            // Show filter bottom sheet
            _showFilterBottomSheet(context);
          },
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppConstants.appPrimaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppConstants.appPrimaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.tune,
              color: AppConstants.appPrimaryColor,
              size: 20,
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Sort Button
        GestureDetector(
          onTap: () {
            // Show sort options
            _showSortBottomSheet(context);
          },
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppConstants.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.sort,
              color: AppConstants.white.withOpacity(0.8),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: 'Filter Options',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
            const SizedBox(height: 24),

            // Price Range
            const CommonTextWidget(
              text: 'Price Range',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppConstants.white,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppConstants.white.withOpacity(0.2),
                      ),
                    ),
                    child: const Center(
                      child: CommonTextWidget(
                        text: 'Min Price',
                        color: AppConstants.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppConstants.white.withOpacity(0.2),
                      ),
                    ),
                    child: const Center(
                      child: CommonTextWidget(
                        text: 'Max Price',
                        color: AppConstants.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.appPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const CommonTextWidget(
                  text: 'Apply Filters',
                  color: AppConstants.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: 'Sort By',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
            const SizedBox(height: 24),

            _buildSortOption('Price: Low to High', Icons.arrow_upward),
            _buildSortOption('Price: High to Low', Icons.arrow_downward),
            _buildSortOption('Newest First', Icons.schedule),
            _buildSortOption('Most Popular', Icons.favorite_outline),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.white.withOpacity(0.6), size: 20),
          const SizedBox(width: 16),
          CommonTextWidget(
            text: title,
            color: AppConstants.white,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}
