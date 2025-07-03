import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_action_buttons_widget.dart';
import '../widgets/profile_ad_card_widget.dart';
import '../widgets/profile_empty_state_widget.dart';
import '../widgets/profile_error_state_widget.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/profile_stats_widget.dart';

class VizzleProfilePage extends StatefulWidget {
  const VizzleProfilePage({super.key});

  @override
  State<VizzleProfilePage> createState() => _VizzleProfilePageState();
}

class _VizzleProfilePageState extends State<VizzleProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppConstants.black, Color(0xFF0A0A0A)],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => context.read<ProfileProvider>().refreshProfile(),
            backgroundColor: AppConstants.black,
            color: AppConstants.appPrimaryColor,
            child: Consumer<ProfileProvider>(
              builder: (context, provider, child) {
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [_buildAppBar(), _buildContent(provider)],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      floating: true,
      snap: true,
      title: const CommonTextWidget(
        text: 'You',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppConstants.white,
      ),
      centerTitle: false,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios, color: AppConstants.white),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: ElevatedButton.icon(
            onPressed: () {
              // Navigate to create ad
              debugPrint('Navigate to create ad');
            },
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Create ad'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: AppConstants.appPrimaryColor,
              side: const BorderSide(
                color: AppConstants.appPrimaryColor,
                width: 1,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(ProfileProvider provider) {
    if (provider.isLoading && !provider.hasProfile) {
      return const SliverFillRemaining(
        child: Center(
          child: LoadingWidget(message: 'Loading your profile...', size: 48),
        ),
      );
    }

    if (provider.hasError && !provider.hasProfile) {
      return SliverFillRemaining(
        child: ProfileErrorStateWidget(
          message: provider.errorMessage ?? 'Something went wrong',
          onRetry: () => provider.loadProfile(),
        ),
      );
    }

    if (!provider.hasProfile) {
      return const SliverFillRemaining(child: ProfileEmptyStateWidget());
    }

    final profile = provider.profile!;

    return SliverList(
      delegate: SliverChildListDelegate([
        const SizedBox(height: 16),

        // Profile Header
        ProfileHeaderWidget(user: profile.user),

        const SizedBox(height: 24),

        // Action Buttons
        const ProfileActionButtonsWidget(),

        const SizedBox(height: 24),

        // Stats Section
        ProfileStatsWidget(totalAdsCount: profile.activeAdsCount),

        const SizedBox(height: 24),

        // Your Ads Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const CommonTextWidget(
                text: 'Your Ads',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
              ),
              const SizedBox(width: 8),
              if (profile.advertisements.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.appPrimaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CommonTextWidget(
                    text: '${profile.advertisements.length}',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.appPrimaryColor,
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Ads List
        if (profile.advertisements.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  CommonTextWidget(
                    text: 'No ads found',
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          )
        else
          ...profile.advertisements.map(
            (ad) => Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: ProfileAdCardWidget(
                ad: ad,
                isOperating: provider.isAdOperating(ad.id),
                onDelete: () => _handleDeleteAd(provider, ad.id),
                onMarkAsSold: () => _handleMarkAsSold(provider, ad.id),
                onEdit: () => _handleEditAd(ad.id),
                onTap: () => _handleAdTap(ad.id, ad.shareLink),
              ),
            ),
          ),

        const SizedBox(height: 24),
      ]),
    );
  }

  Future<void> _handleDeleteAd(ProfileProvider provider, String adId) async {
    final success = await provider.deleteAd(adId);

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Ad deleted successfully' : 'Failed to delete ad',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _handleMarkAsSold(ProfileProvider provider, String adId) async {
    final success = await provider.markAsSold(adId);

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Status updated successfully' : 'Failed to update status',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _handleEditAd(String adId) {
    // Navigate to edit ad screen
    debugPrint('Edit ad: $adId');
  }

  void _handleAdTap(String adId, String shareLink) {
    context.push(
      '${RouteConstants.productDetail}?shareUrl=${Uri.encodeComponent(shareLink)}&isPersonal=false',
    );
  }
}
