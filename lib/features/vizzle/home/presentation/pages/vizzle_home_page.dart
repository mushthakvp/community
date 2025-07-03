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

class _VizzleHomePageState extends State<VizzleHomePage>
    with TickerProviderStateMixin {
  late AnimationController _searchAnimationController;
  late AnimationController _profileAnimationController;
  late AnimationController _createAdAnimationController;
  late Animation<double> _searchScaleAnimation;
  late Animation<double> _profileScaleAnimation;
  late Animation<double> _createAdScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _profileAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _createAdAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Initialize animations
    _searchScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _searchAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _profileScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _profileAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _createAdScaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _createAdAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VizzleHomeProvider>().loadVizzleHome();
    });
  }

  @override
  void dispose() {
    _searchAnimationController.dispose();
    _profileAnimationController.dispose();
    _createAdAnimationController.dispose();
    super.dispose();
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
                        // Enhanced Create Ad and Profile Button Row
                        _buildActionButtonsRow(),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppConstants.appPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.store,
              color: AppConstants.appPrimaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const CommonTextWidget(
            text: 'Vizzle Marketplace',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppConstants.white,
          ),
        ],
      ),
      actions: [
        AnimatedBuilder(
          animation: _searchScaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _searchScaleAnimation.value,
              child: GestureDetector(
                onTapDown: (_) => _searchAnimationController.forward(),
                onTapUp: (_) {
                  _searchAnimationController.reverse();
                  context.push(RouteConstants.vizzleSearch);
                },
                onTapCancel: () => _searchAnimationController.reverse(),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppConstants.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppConstants.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: AppConstants.white,
                    size: 20,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildActionButtonsRow() {
    return Row(
      children: [
        // Enhanced Create Ad Button
        Expanded(
          flex: 2,
          child: AnimatedBuilder(
            animation: _createAdScaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _createAdScaleAnimation.value,
                child: GestureDetector(
                  onTapDown: (_) => _createAdAnimationController.forward(),
                  onTapUp: (_) {
                    _createAdAnimationController.reverse();
                    context.push(RouteConstants.selectCity);
                  },
                  onTapCancel: () => _createAdAnimationController.reverse(),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppConstants.appPrimaryColor,
                          AppConstants.appPrimaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.appPrimaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: AppConstants.black,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        const CommonTextWidget(
                          text: 'Create Your Ad',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.black,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 16),

        // Enhanced Profile Button
        AnimatedBuilder(
          animation: _profileScaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _profileScaleAnimation.value,
              child: GestureDetector(
                onTapDown: (_) => _profileAnimationController.forward(),
                onTapUp: (_) {
                  _profileAnimationController.reverse();
                  context.push(RouteConstants.vizzleProfile);
                },
                onTapCancel: () => _profileAnimationController.reverse(),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppConstants.appPrimaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.appPrimaryColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppConstants.appPrimaryColor.withOpacity(
                              0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: AppConstants.appPrimaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                      // Active indicator (optional)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AppConstants.black,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
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
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1A1A1A),
                const Color(0xFF2A2A2A).withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppConstants.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.appPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 40,
                  color: AppConstants.appPrimaryColor.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 16),
              const CommonTextWidget(
                text: 'No ads yet',
                fontSize: 18,
                fontWeight: FontWeight.w600,
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
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push(RouteConstants.selectCity);
                  },
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: const Text('Create First Ad'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.appPrimaryColor,
                    foregroundColor: AppConstants.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
