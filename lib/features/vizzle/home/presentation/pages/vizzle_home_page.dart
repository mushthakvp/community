import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/vizzle_home_provider.dart';
import '../widgets/vizzle_marketplace_categories.dart';
import '../widgets/vizzle_recent_ads_section.dart';

class VizzleHomePage extends StatefulWidget {
  const VizzleHomePage({super.key});

  @override
  State<VizzleHomePage> createState() => _VizzleHomePageState();
}

class _VizzleHomePageState extends State<VizzleHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VizzleHomeProvider>().loadVizzleHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: _buildAppBar(),
      body: Consumer<VizzleHomeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && !provider.hasData) {
            return const Center(child: LoadingWidget());
          }
          return RefreshIndicator(
            onRefresh: () => provider.refreshData(),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Create Ad Button
                        _buildCreateAdButton(),
                        const SizedBox(height: 24),

                        _buildSectionHeader('Browse Categories'),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  sliver: VizzleMarketplaceCategories(),
                ),

                // Always show recent ads section (with mock data if needed)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionHeader('Recent Ads'),
                        GestureDetector(
                          onTap: () {
                            context.push(RouteConstants.vizzleAdsListing);
                          },
                          child: const CommonTextWidget(
                            text: 'View All',
                            color: AppConstants.appPrimaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Recent Ads Section - Show even with mock data
                _buildRecentAdsSection(provider),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppConstants.black,
      elevation: 0,
      title: Row(
        children: [
          const SizedBox(width: 8),
          const CommonTextWidget(
            text: 'Vizzle Marketplace',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppConstants.white,
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            context.push(RouteConstants.vizzleSearch);
          },
          icon: const Icon(Icons.search, color: AppConstants.white, size: 24),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildCreateAdButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          context.push(RouteConstants.selectCity);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.appPrimaryColor,
          foregroundColor: AppConstants.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        icon: const Icon(Icons.add_circle_outline, size: 24),
        label: const CommonTextWidget(
          text: 'Create Your Ad',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppConstants.black,
        ),
      ),
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

  Widget _buildRecentAdsSection(VizzleHomeProvider provider) {
    // If we have data from the provider, use it
    if (provider.vizzleHome != null && provider.vizzleHome!.hasAnyAds) {
      return VizzleRecentAdsSection(vizzleHome: provider.vizzleHome!);
    }

    // Otherwise, show a mock/placeholder section or empty state
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppConstants.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 48,
                color: AppConstants.white.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              const CommonTextWidget(
                text: 'No ads yet',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppConstants.white,
                align: TextAlign.center,
              ),
              const SizedBox(height: 8),
              CommonTextWidget(
                text: 'Be the first to create an ad and start selling!',
                fontSize: 14,
                color: AppConstants.white.withOpacity(0.6),
                align: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.push(RouteConstants.selectCity);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.appPrimaryColor,
                  foregroundColor: AppConstants.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Create First Ad'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
