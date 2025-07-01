import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/saved_ads_provider.dart';
import '../widgets/saved_ad_card.dart';
import '../widgets/saved_ads_empty_state.dart';
import '../widgets/saved_ads_error_state.dart';

class SavedAdsPage extends StatefulWidget {
  const SavedAdsPage({super.key});

  @override
  State<SavedAdsPage> createState() => _SavedAdsPageState();
}

class _SavedAdsPageState extends State<SavedAdsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavedAdsProvider>().loadSavedAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Saved Ads', showBackButton: true),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppConstants.black, Color(0xFF0A0A0A)],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () => context.read<SavedAdsProvider>().refreshSavedAds(),
          backgroundColor: AppConstants.black,
          color: AppConstants.appPrimaryColor,
          child: Consumer<SavedAdsProvider>(
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

  Widget _buildHeader(SavedAdsProvider provider) {
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
                    Icons.favorite,
                    color: AppConstants.appPrimaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: CommonTextWidget(
                    text: 'Your Favorites',
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
            if (provider.savedAdsCount > 0) ...[
              const SizedBox(height: 8),
              CommonTextWidget(
                text:
                    '${provider.savedAdsCount} saved ${provider.savedAdsCount == 1 ? 'ad' : 'ads'}',
                fontSize: 14,
                color: AppConstants.white.withOpacity(0.7),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent(SavedAdsProvider provider) {
    if (provider.isLoading && provider.savedAds.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: LoadingWidget(message: 'Loading your saved ads...', size: 48),
        ),
      );
    }

    if (provider.hasError) {
      return SliverFillRemaining(
        child: SavedAdsErrorState(
          message: provider.errorMessage ?? 'Something went wrong',
          onRetry: () => provider.loadSavedAds(),
        ),
      );
    }

    if (provider.isEmpty) {
      return const SliverFillRemaining(child: SavedAdsEmptyState());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index >= provider.savedAds.length) return null;

          final ad = provider.savedAds[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SavedAdCard(
              ad: ad,
              isToggling: provider.isAdToggling(ad.id),
              onToggleFavorite: () => _handleToggleFavorite(provider, ad.id),
              onTap: () => _handleAdTap(ad.id),
            ),
          );
        }, childCount: provider.savedAds.length),
      ),
    );
  }

  Future<void> _handleToggleFavorite(
    SavedAdsProvider provider,
    String adId,
  ) async {
    final success = await provider.toggleFavorite(adId);

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Removed from favorites'
                : 'Failed to remove from favorites',
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
}
