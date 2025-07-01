import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/recently_viewed_provider.dart';
import '../widgets/recently_viewed_ad_card.dart';
import '../widgets/recently_viewed_empty_state.dart';
import '../widgets/recently_viewed_error_state.dart';

class RecentlyViewedPage extends StatefulWidget {
  const RecentlyViewedPage({super.key});

  @override
  State<RecentlyViewedPage> createState() => _RecentlyViewedPageState();
}

class _RecentlyViewedPageState extends State<RecentlyViewedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecentlyViewedProvider>().loadRecentlyViewedAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: CommonAppBar(
        title: 'Recently Viewed',
        showBackButton: true,
        actions: [
          Consumer<RecentlyViewedProvider>(
            builder: (context, provider, child) {
              if (provider.recentlyViewedAds.isNotEmpty) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppConstants.white),
                  color: const Color(0xFF1A1A1A),
                  onSelected: (value) {
                    if (value == 'clear_all') {
                      _showClearAllDialog(provider);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'clear_all',
                      child: Row(
                        children: [
                          Icon(
                            Icons.clear_all,
                            color: Colors.red.withOpacity(0.8),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const CommonTextWidget(
                            text: 'Clear All',
                            color: AppConstants.white,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppConstants.black, Color(0xFF0A0A0A)],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () =>
              context.read<RecentlyViewedProvider>().refreshRecentlyViewedAds(),
          backgroundColor: AppConstants.black,
          color: AppConstants.appPrimaryColor,
          child: Consumer<RecentlyViewedProvider>(
            builder: (context, provider, child) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [_buildHeader(provider), _buildContent(provider)],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(RecentlyViewedProvider provider) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.appPrimaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.history,
                    color: AppConstants.appPrimaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: CommonTextWidget(
                    text: 'Your Recent Views',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.white,
                  ),
                ),
                if (provider.isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppConstants.appPrimaryColor,
                      ),
                    ),
                  ),
              ],
            ),
            if (provider.recentlyViewedCount > 0) ...[
              const SizedBox(height: 8),
              CommonTextWidget(
                text:
                    '${provider.recentlyViewedCount} recently viewed ${provider.recentlyViewedCount == 1 ? 'ad' : 'ads'}',
                fontSize: 14,
                color: AppConstants.white.withOpacity(0.7),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent(RecentlyViewedProvider provider) {
    if (provider.isLoading && provider.recentlyViewedAds.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: LoadingWidget(
            message: 'Loading recently viewed ads...',
            size: 48,
          ),
        ),
      );
    }

    if (provider.hasError) {
      return SliverFillRemaining(
        child: RecentlyViewedErrorState(
          message: provider.errorMessage ?? 'Something went wrong',
          onRetry: () => provider.loadRecentlyViewedAds(),
        ),
      );
    }

    if (provider.isEmpty) {
      return const SliverFillRemaining(child: RecentlyViewedEmptyState());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index >= provider.recentlyViewedAds.length) return null;

          final ad = provider.recentlyViewedAds[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RecentlyViewedAdCard(
              ad: ad,
              isToggling: provider.isAdToggling(ad.id),
              onToggleFavorite: () => _handleToggleFavorite(provider, ad.id),
              onTap: () => _handleAdTap(ad.id),
            ),
          );
        }, childCount: provider.recentlyViewedAds.length),
      ),
    );
  }

  Future<void> _handleToggleFavorite(
    RecentlyViewedProvider provider,
    String adId,
  ) async {
    final success = await provider.toggleFavorite(adId);

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Added to favorites' : 'Failed to update favorite',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleAdTap(String adId) {
    // Navigate to ad details
    // context.push('/vizzle/ad/$adId');
    debugPrint('Navigate to ad: $adId');
  }

  void _showClearAllDialog(RecentlyViewedProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const CommonTextWidget(
          text: 'Clear All Recently Viewed?',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        content: const CommonTextWidget(
          text:
              'This will remove all ads from your recently viewed list. This action cannot be undone.',
          fontSize: 14,
          color: AppConstants.white,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const CommonTextWidget(
              text: 'Cancel',
              color: AppConstants.white,
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await provider.clearAllRecentlyViewed();
              if (mounted) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Recently viewed cleared'
                          : 'Failed to clear recently viewed',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const CommonTextWidget(text: 'Clear All', color: Colors.red),
          ),
        ],
      ),
    );
  }
}
