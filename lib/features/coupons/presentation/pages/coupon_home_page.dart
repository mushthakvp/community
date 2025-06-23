// lib/features/coupons/presentation/pages/coupon_home_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/secure_storage.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../home/presentation/widgets/user_not_logged_widget.dart';
import '../../data/models/coupon_model.dart';
import '../providers/coupon_provider.dart';
import '../providers/coupon_state.dart';
import '../widgets/app_filter.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_filter.dart';
import '../widgets/coupon_card.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/search_bar_widget.dart';

class CouponHomePage extends StatefulWidget {
  const CouponHomePage({super.key});

  @override
  State<CouponHomePage> createState() => _CouponHomePageState();
}

class _CouponHomePageState extends State<CouponHomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CouponProvider>().initializeCoupons();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AppPref.isLogin == true
        ? _buildAuthenticatedView()
        : _buildUnauthenticatedView();
  }

  Widget _buildAuthenticatedView() {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: _buildAppBar(),
      body: Consumer<CouponProvider>(
        builder: (context, provider, child) {
          return _buildBody(provider);
        },
      ),
    );
  }

  Widget _buildUnauthenticatedView() {
    return const Scaffold(
      backgroundColor: Colors.black54,
      body: UserNotLoggedWidget(isArrowEnabled: true),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppConstants.black,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: const Icon(Icons.arrow_back_rounded, color: AppConstants.white),
      ),
      centerTitle: false,
      title: const CommonTextWidget(
        text: 'Coupons',
        align: TextAlign.start,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppConstants.white,
      ),
      actions: [
        IconButton(
          onPressed: () =>
              context.read<CouponProvider>().loadCoupons(forceRefresh: true),
          icon: const Icon(Icons.refresh, color: AppConstants.white),
        ),
      ],
    );
  }

  Widget _buildBody(CouponProvider provider) {
    return RefreshIndicator(
      onRefresh: () => provider.loadCoupons(forceRefresh: true),
      color: AppConstants.appPrimaryColor,
      backgroundColor: AppConstants.black,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Search Bar
                SearchBarWidget(
                  controller: provider.searchController,
                  onChanged: provider.onSearchChanged,
                ),
                const SizedBox(height: 20),

                // Content based on state
                _buildStateContent(provider),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateContent(CouponProvider provider) {
    final state = provider.state;

    if (state is CouponLoading) {
      return _buildLoadingState();
    }

    if (state is CouponError) {
      return CouponErrorWidget(
        message: state.message,
        canRetry: state.canRetry,
        onRetry: state.canRetry
            ? () => provider.loadCoupons(forceRefresh: true)
            : null,
      );
    }

    if (state is CouponLoaded) {
      return _buildLoadedContent(state, provider);
    }

    // Initial state or unknown state
    return _buildLoadingState();
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        const SizedBox(height: 100),
        const LoadingWidget(),
        const SizedBox(height: 20),
        const CommonTextWidget(
          text: 'Loading coupons...',
          color: AppConstants.white,
          fontSize: 16,
        ),
      ],
    );
  }

  Widget _buildLoadedContent(CouponLoaded state, CouponProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner Carousel
        if (state.coupons.banners?.isNotEmpty == true) ...[
          BannerCarousel(banners: state.coupons.banners!),
          const SizedBox(height: 30),
        ],

        // Category Filter
        if (state.categories.length > 1) ...[
          CategoryFilter(
            categories: state.categories,
            selectedCategoryId: state.selectedCategoryId,
            onCategorySelected: provider.onCategorySelected,
          ),
          const SizedBox(height: 20),
        ],

        // App Filter
        if (state.apps.isNotEmpty) ...[
          AppFilter(
            apps: state.apps,
            selectedAppId: state.selectedAppId,
            onAppSelected: provider.onAppSelected,
          ),
          const SizedBox(height: 30),
        ],

        // Coupons List
        _buildCouponsList(state.filteredCoupons, provider),
      ],
    );
  }

  Widget _buildCouponsList(
    List<CouponReward> coupons,
    CouponProvider provider,
  ) {
    if (coupons.isEmpty) {
      return EmptyStateWidget(
        message: provider.searchController.text.isNotEmpty
            ? 'No coupons found for "${provider.searchController.text}"'
            : 'No coupons available',
        onRefresh: () => provider.loadCoupons(forceRefresh: true),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: coupons.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return CouponCard(
          coupon: coupons[index],
          onLike: () => provider.likeCoupon(coupons[index].id ?? ''),
          onDislike: (reason) =>
              provider.dislikeCoupon(coupons[index].id ?? '', reason),
          onUse: () => provider.useCoupon(coupons[index].id ?? ''),
          formatLastUsedTime: provider.formatLastUsedTime,
        );
      },
    );
  }
}
