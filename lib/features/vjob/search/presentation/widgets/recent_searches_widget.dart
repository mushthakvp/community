import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../providers/search_provider.dart';

class RecentSearchesWidget extends StatelessWidget {
  const RecentSearchesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, provider, _) {
        if (provider.recentSearches.isEmpty) {
          return _buildEmptyRecentSearches();
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonTextWidget(
                text: 'Recent Searches',
                color: AppConstants.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: provider.recentSearches.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final search = provider.recentSearches[index];
                    return _buildRecentSearchItem(
                      searchTerm: search.searchTerm,
                      createdAt: search.createdAt,
                      onTap: () =>
                          provider.selectRecentSearch(search.searchTerm),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentSearchItem({
    required String searchTerm,
    required DateTime createdAt,
    required VoidCallback onTap,
  }) {
    final timeAgo = timeago.format(createdAt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xff0F0F0F),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppConstants.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.history,
              color: AppConstants.white.withOpacity(0.6),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget(
                    text: searchTerm,
                    color: AppConstants.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 2),
                  CommonTextWidget(
                    text: timeAgo,
                    color: AppConstants.white.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppConstants.white.withOpacity(0.4),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyRecentSearches() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: AppConstants.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            CommonTextWidget(
              text: 'No recent searches',
              fontSize: 18,
              color: AppConstants.white.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: 'Start searching for jobs, companies, or cities',
              fontSize: 14,
              color: AppConstants.white.withOpacity(0.6),
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
