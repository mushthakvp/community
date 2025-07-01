import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/vizzle_home_provider.dart';
import '../widgets/vizzle_home_search_bar.dart';
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
                        const VizzleHomeSearchBar(),
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
                if (provider.vizzleHome?.hasAnyAds == true) ...[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionHeader('Recent Ads'),
                          GestureDetector(
                            onTap: () {},
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
                  VizzleRecentAdsSection(vizzleHome: provider.vizzleHome!),
                ],
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
          onPressed: () {},
          icon: Stack(
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: AppConstants.white,
                size: 24,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    color: AppConstants.appPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
      ],
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
}
