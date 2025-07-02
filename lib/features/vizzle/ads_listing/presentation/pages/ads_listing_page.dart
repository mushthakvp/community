import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../domain/entities/ads_filter_entity.dart';
import '../providers/ads_listing_provider.dart';
import '../widgets/ads_empty_state.dart';
import '../widgets/ads_error_widget.dart';
import '../widgets/ads_filter_bar.dart';
import '../widgets/ads_grid_view.dart';
import '../widgets/ads_list_view.dart';
import '../widgets/ads_search_bar.dart';

enum AdsViewType { grid, list }

class AdsListingPage extends StatefulWidget {
  final String? categoryId;
  final String? subCategoryId;
  final String? subSubCategoryId;
  final String? subItemId;
  final String? categoryName;
  final String? subCategoryName;
  final String? subSubCategoryName;
  final String? subItemName;
  final AdsFilterEntity? initialFilter;

  const AdsListingPage({
    super.key,
    this.categoryId,
    this.subCategoryId,
    this.subSubCategoryId,
    this.subItemId,
    this.categoryName,
    this.subCategoryName,
    this.subSubCategoryName,
    this.subItemName,
    this.initialFilter,
  });

  @override
  State<AdsListingPage> createState() => _AdsListingPageState();
}

class _AdsListingPageState extends State<AdsListingPage> {
  final ScrollController _scrollController = ScrollController();
  AdsViewType _viewType = AdsViewType.grid;
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
    _initializeData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      // Show scroll to top button
      final showButton = _scrollController.offset > 500;
      if (showButton != _showScrollToTop) {
        setState(() {
          _showScrollToTop = showButton;
        });
      }

      // Load more when reaching bottom
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<AdsListingProvider>().loadMoreAds();
      }
    });
  }

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AdsListingProvider>();

      // Load filter options
      provider.loadFilterOptions();

      // Create filter based on the navigation parameters
      AdsFilterEntity filter = widget.initialFilter ?? const AdsFilterEntity();

      // Build filter based on passed parameters
      if (widget.categoryId != null) {
        filter = filter.copyWith(categoryId: widget.categoryId);
      }
      if (widget.subCategoryId != null) {
        filter = filter.copyWith(subCategoryId: widget.subCategoryId);
      }

      // For more specific filters, we might need to extend the filter entity
      // or handle them in a different way based on your API requirements

      // Load ads with the constructed filter
      provider.loadAds(filter: filter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: _buildAppBar(),
      body: Consumer<AdsListingProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Search and filter bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    AdsSearchBar(
                      onSearch: provider.searchAds,
                      currentKeyword: provider.currentFilter.keyword,
                    ),
                    const SizedBox(height: 12),
                    AdsFilterBar(
                      currentFilter: provider.currentFilter,
                      filterOptions: provider.filterOptions,
                      onFilterChanged: provider.updateFilter,
                      onFilterCleared: provider.clearFilter,
                      onViewTypeChanged: (viewType) {
                        setState(() {
                          _viewType = viewType;
                        });
                      },
                      currentViewType: _viewType,
                    ),
                  ],
                ),
              ),

              // Content area
              Expanded(child: _buildContent(provider)),
            ],
          );
        },
      ),
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton(
              mini: true,
              onPressed: _scrollToTop,
              backgroundColor: AppConstants.appPrimaryColor,
              child: const Icon(
                Icons.keyboard_arrow_up,
                color: AppConstants.black,
              ),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    String title = _buildTitle();

    return CommonAppBar(
      title: title,
      showBackButton: true,
      actions: [
        Consumer<AdsListingProvider>(
          builder: (context, provider, child) {
            if (provider.hasData) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Center(
                  child: Text(
                    '${provider.totalCount} ads',
                    style: const TextStyle(
                      color: AppConstants.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  String _buildTitle() {
    // Build title based on the navigation hierarchy
    if (widget.subItemName != null) {
      return widget.subItemName!;
    } else if (widget.subSubCategoryName != null) {
      return widget.subSubCategoryName!;
    } else if (widget.subCategoryName != null) {
      return widget.subCategoryName!;
    } else if (widget.categoryName != null) {
      return widget.categoryName!;
    } else {
      return 'Ads';
    }
  }

  Widget _buildContent(AdsListingProvider provider) {
    if (provider.isLoading && !provider.hasData) {
      return const Center(child: LoadingWidget());
    }

    if (provider.hasError && !provider.hasData) {
      return AdsErrorWidget(
        message: provider.errorMessage ?? 'Something went wrong',
        onRetry: () => provider.refreshAds(),
      );
    }

    if (provider.isEmpty) {
      return AdsEmptyState(
        hasActiveFilters: provider.currentFilter.hasActiveFilters,
        onClearFilters: provider.clearFilter,
      );
    }

    return RefreshIndicator(
      onRefresh: provider.refreshAds,
      child: _viewType == AdsViewType.grid
          ? AdsGridView(
              ads: provider.ads,
              scrollController: _scrollController,
              isLoadingMore: provider.isLoadingMore,
              onAdTap: _handleAdTap,
              onFavoriteTap: provider.toggleAdFavorite,
            )
          : AdsListView(
              ads: provider.ads,
              scrollController: _scrollController,
              isLoadingMore: provider.isLoadingMore,
              onAdTap: _handleAdTap,
              onFavoriteTap: provider.toggleAdFavorite,
            ),
    );
  }

  void _handleAdTap(String adId) {
    // Navigate to ad details page
    // context.push('/ads/$adId');
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
