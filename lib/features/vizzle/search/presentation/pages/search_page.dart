import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/image_widget.dart';
import '../../../../../core/widgets/common/spacer_widget.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../domain/entities/search_result.dart';
import '../providers/search_provider.dart';

class SearchPage extends StatefulWidget {
  final String? initialQuery;
  final String? categoryId;
  final String? location;
  final double? minPrice;
  final double? maxPrice;

  const SearchPage({
    super.key,
    this.initialQuery,
    this.categoryId,
    this.location,
    this.minPrice,
    this.maxPrice,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');

    // Initial search if query provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SearchProvider>();
      if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
        provider.searchAds(widget.initialQuery!);
      } else {
        provider.searchAds(''); // Empty search to show initial state
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Search', showBackButton: true),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppConstants.black, AppConstants.surfaceVariant],
          ),
        ),
        child: Column(
          children: [
            _buildSearchHeader(),
            Expanded(child: _buildSearchResults()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: CommonTextField(
              controller: _searchController,
              hintText: 'Search products...',
              prefixIcon: const Icon(
                Icons.search,
                color: AppConstants.onSurfaceVariant,
              ),
              onChanged: (value) {
                context.read<SearchProvider>().searchAds(value);
              },
              borderRadius: 25,
            ),
          ),
          AppSpacing.horizontalSM,
          // Filter button
          IconButton(
            onPressed: () => _showFilterBottomSheet(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.filter_list,
                color: AppConstants.black,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Consumer<SearchProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: LoadingWidget(message: 'Searching...'));
        }

        final result = provider.searchResult;
        if (result == null) {
          return _buildEmptyState();
        }

        if (result.isError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppConstants.error,
                  size: 64,
                ),
                AppSpacing.verticalMD,
                CommonTextWidget(
                  text: result.errorMessage ?? 'Something went wrong',
                  fontSize: 16,
                  align: TextAlign.center,
                ),
                AppSpacing.verticalMD,
                ElevatedButton(
                  onPressed: () {
                    context.read<SearchProvider>().searchAds(
                      _searchController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.appPrimaryColor,
                    foregroundColor: AppConstants.black,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // FIXED: Use the correct getter
        final searchData = result.data;
        if (searchData == null || searchData.ads.isEmpty) {
          return _buildNoResultsState();
        }

        return _buildSearchGrid(searchData);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppConstants.surfaceVariant,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.search,
              color: AppConstants.appPrimaryColor,
              size: 48,
            ),
          ),
          AppSpacing.verticalLG,
          const CommonTextWidget(
            text: 'Start your search',
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          AppSpacing.verticalSM,
          const CommonTextWidget(
            text: 'Type in keywords to find what you\'re looking for',
            fontSize: 16,
            color: AppConstants.onSurfaceVariant,
            align: TextAlign.center,
          ),
          AppSpacing.verticalLG,
          _buildPopularSearches(),
        ],
      ),
    );
  }

  Widget _buildPopularSearches() {
    final popularSearches = [
      'Electronics',
      'Cars',
      'Furniture',
      'Books',
      'Clothes',
    ];

    return Column(
      children: [
        const CommonTextWidget(
          text: 'Popular searches',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppConstants.onSurfaceVariant,
        ),
        AppSpacing.verticalSM,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: popularSearches.map((search) {
            return GestureDetector(
              onTap: () {
                _searchController.text = search;
                context.read<SearchProvider>().searchAds(search);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppConstants.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppConstants.appPrimaryColor.withOpacity(0.3),
                  ),
                ),
                child: CommonTextWidget(
                  text: search,
                  fontSize: 14,
                  color: AppConstants.appPrimaryColor,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppConstants.surfaceVariant,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.search_off,
              color: AppConstants.onSurfaceVariant,
              size: 48,
            ),
          ),
          AppSpacing.verticalLG,
          const CommonTextWidget(
            text: 'No results found',
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          AppSpacing.verticalSM,
          const CommonTextWidget(
            text: 'Try adjusting your search or filters',
            fontSize: 16,
            color: AppConstants.onSurfaceVariant,
            align: TextAlign.center,
          ),
          AppSpacing.verticalLG,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _searchController.clear();
                  context.read<SearchProvider>().clearSearch();
                },
                icon: const Icon(Icons.clear),
                label: const Text('Clear Search'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.surfaceVariant,
                  foregroundColor: AppConstants.white,
                ),
              ),
              AppSpacing.horizontalMD,
              ElevatedButton.icon(
                onPressed: _showFilterBottomSheet,
                icon: const Icon(Icons.filter_list),
                label: const Text('Filters'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.appPrimaryColor,
                  foregroundColor: AppConstants.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchGrid(SearchResult searchData) {
    return Column(
      children: [
        // Results count header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: CommonTextWidget(
            text: '${searchData.totalAds} results found',
            fontSize: 14,
            color: AppConstants.onSurfaceVariant,
          ),
        ),
        // Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: searchData.ads.length,
            itemBuilder: (context, index) {
              final ad = searchData.ads[index];
              return _buildAdCard(ad);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdCard(SearchAd ad) {
    return GestureDetector(
      onTap: () => _onAdTap(ad),
      child: Container(
        decoration: BoxDecoration(
          color: AppConstants.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppConstants.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  CommonImageWidget(
                    imageUrl: ad.images.isNotEmpty ? ad.images.first : null,
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppConstants.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: AppConstants.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppConstants.white.withOpacity(0.1),
                      AppConstants.white.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextWidget(
                      text: 'INR ${ad.price.toStringAsFixed(2)}',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.appPrimaryColor,
                      maxLines: 1,
                    ),
                    CommonTextWidget(
                      text: ad.title,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      maxLines: 2,
                    ),
                    if (ad.brand != null)
                      CommonTextWidget(
                        text: ad.brand!,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppConstants.onSurfaceVariant,
                        maxLines: 1,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onAdTap(SearchAd ad) {
    context.push(
      '${RouteConstants.productDetail}?shareUrl=${Uri.encodeComponent(ad.shareLink ?? "")}&isPersonal=false',
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppConstants.surfaceVariant,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppConstants.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(
                  child: CommonTextWidget(
                    text: 'Search Filters',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppConstants.white),
                ),
              ],
            ),
          ),
          // Filter content
          const Expanded(
            child: Center(
              child: CommonTextWidget(
                text: 'Filter options will be implemented here',
                fontSize: 16,
                color: AppConstants.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
