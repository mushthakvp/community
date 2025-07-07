import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/vizzle/ads_listing/presentation/pages/ads_listing_page.dart';
import '../../../features/vizzle/edit_ad/presentation/pages/edit_ad_page.dart';
import '../../../features/vizzle/home/presentation/pages/vizzle_home_page.dart';
import '../../../features/vizzle/place_add/presentation/pages/create_ad_page.dart';
import '../../../features/vizzle/place_add/presentation/pages/location_picker_page.dart';
import '../../../features/vizzle/place_add/presentation/pages/select_category_page.dart';
import '../../../features/vizzle/place_add/presentation/pages/select_city_page.dart';
import '../../../features/vizzle/place_add/presentation/pages/select_subcategory_page.dart';
import '../../../features/vizzle/product_detail/presentation/pages/product_detail_page.dart';
import '../../../features/vizzle/product_detail/presentation/pages/report_product_page.dart';
import '../../../features/vizzle/profile/presentation/pages/vizzle_profile_page.dart';
import '../../../features/vizzle/recently_viewed/presentation/pages/recently_viewed_page.dart';
import '../../../features/vizzle/saved_view/presentation/pages/saved_ads_page.dart';
import '../../../features/vizzle/search/presentation/pages/search_page.dart';
import '../../../features/vizzle/seller_details/presentation/pages/seller_details_page.dart';
import '../../../features/vizzle/sub_category_listing/presentation/pages/sub_category_listing_page.dart';
import '../../../features/vizzle/sub_items_view/presentation/pages/sub_items_page.dart';
import '../../../features/vizzle/sub_sub_category_list_view/presentation/pages/sub_sub_category_page.dart';
import '../../constants/app_constants.dart';
import '../../constants/route_constants.dart';

class VizzleRouter {
  /// Vizzle marketplace routes
  static List<RouteBase> get routes => [
    // ==================== VIZZLE HOME ROUTES ====================
    GoRoute(
      path: RouteConstants.vizzleHome,
      name: 'vizzleHome',
      builder: (context, state) => const VizzleHomePage(),
    ),

    // ==================== PLACE AD FLOW ROUTES ====================
    GoRoute(
      path: RouteConstants.selectCity,
      name: 'selectCity',
      builder: (context, state) => const SelectCityPage(),
    ),
    GoRoute(
      path: RouteConstants.selectCategory,
      name: 'selectCategory',
      builder: (context, state) => const SelectCategoryPage(),
    ),
    GoRoute(
      path: RouteConstants.selectSubCategory,
      name: 'selectSubCategory',
      builder: (context, state) => const SelectSubCategoryPage(),
    ),
    GoRoute(
      path: RouteConstants.createAd,
      name: 'createAd',
      builder: (context, state) => const CreateAdPage(),
    ),
    GoRoute(
      path: RouteConstants.locationPicker,
      name: 'locationPicker',
      builder: (context, state) {
        final queryParams = state.uri.queryParameters;
        return LocationPickerPage(
          initialLatitude: double.tryParse(queryParams['lat'] ?? ''),
          initialLongitude: double.tryParse(queryParams['lng'] ?? ''),
        );
      },
    ),

    // ==================== EDIT AD ROUTES ====================
    GoRoute(
      path: '${RouteConstants.editAd}/:adId',
      name: 'editAd',
      builder: (context, state) {
        final adId = state.pathParameters['adId'];

        if (adId == null || adId.isEmpty) {
          return _buildErrorPage('Invalid ad ID');
        }

        return EditAdPage(adId: adId);
      },
    ),

    // ==================== CATEGORY SPECIFIC CREATE AD ROUTES ====================
    GoRoute(
      path: RouteConstants.createMotorAd,
      name: 'createMotorAd',
      builder: (context, state) => const CreateAdPage(),
    ),
    GoRoute(
      path: RouteConstants.createPropertyAd,
      name: 'createPropertyAd',
      builder: (context, state) => const CreateAdPage(),
    ),
    GoRoute(
      path: RouteConstants.createElectronicsAd,
      name: 'createElectronicsAd',
      builder: (context, state) => const CreateAdPage(),
    ),
    GoRoute(
      path: RouteConstants.createFurnitureAd,
      name: 'createFurnitureAd',
      builder: (context, state) => const CreateAdPage(),
    ),
    GoRoute(
      path: RouteConstants.createFarmFreshAd,
      name: 'createFarmFreshAd',
      builder: (context, state) => const CreateAdPage(),
    ),
    GoRoute(
      path: RouteConstants.createCommunityAd,
      name: 'createCommunityAd',
      builder: (context, state) => const CreateAdPage(),
    ),

    // ==================== PRODUCT DETAIL ROUTES ====================
    GoRoute(
      path: RouteConstants.productDetail,
      name: 'productDetail',
      builder: (context, state) {
        final queryParams = state.uri.queryParameters;
        final shareUrl = queryParams['shareUrl'];
        final isPersonal = queryParams['isPersonal'] == 'true';

        if (shareUrl == null || shareUrl.isEmpty) {
          return _buildErrorPage('Invalid product URL');
        }

        return ProductDetailPage(shareUrl: shareUrl, isPersonal: isPersonal);
      },
    ),
    GoRoute(
      path: RouteConstants.reportProduct,
      name: 'reportProduct',
      builder: (context, state) {
        final queryParams = state.uri.queryParameters;
        final productId = queryParams['productId'];
        final productTitle = queryParams['title'] ?? 'Product';

        if (productId == null || productId.isEmpty) {
          return _buildErrorPage('Invalid product ID');
        }

        return ReportProductPage(
          productId: productId,
          productTitle: productTitle,
        );
      },
    ),

    // ==================== SEARCH ROUTES ====================
    GoRoute(
      path: RouteConstants.vizzleSearch,
      name: 'vizzleSearch',
      builder: (context, state) {
        final queryParams = state.uri.queryParameters;
        return SearchPage(
          initialQuery: queryParams['q'],
          categoryId: queryParams['categoryId'],
          location: queryParams['location'],
          minPrice: double.tryParse(queryParams['minPrice'] ?? ''),
          maxPrice: double.tryParse(queryParams['maxPrice'] ?? ''),
        );
      },
    ),
    GoRoute(
      path: RouteConstants.vizzleAdvancedSearch,
      name: 'vizzleAdvancedSearch',
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      path: RouteConstants.vizzleSearchFilters,
      name: 'vizzleSearchFilters',
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      path: RouteConstants.vizzleSearchHistory,
      name: 'vizzleSearchHistory',
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      path: RouteConstants.vizzleSearchSuggestions,
      name: 'vizzleSearchSuggestions',
      builder: (context, state) => const SearchPage(),
    ),

    // ==================== ADS LISTING ROUTES ====================
    GoRoute(
      path: RouteConstants.vizzleAdsListing,
      name: 'vizzleAdsListing',
      builder: (context, state) {
        final queryParams = state.uri.queryParameters;
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final combinedData = <String, dynamic>{...queryParams, ...extra};

        return AdsListingPage(
          categoryId: combinedData['categoryId'],
          subCategoryId: combinedData['subCategoryId'],
          categoryName: combinedData['categoryName'],
          subCategoryName: combinedData['subCategoryName'],
          initialFilter: combinedData['initialFilter'],
        );
      },
    ),

    // ==================== USER CONTENT ROUTES ====================
    GoRoute(
      path: RouteConstants.vizzleRecentlyViewed,
      name: 'vizzleRecentlyViewed',
      builder: (context, state) => const RecentlyViewedPage(),
    ),
    GoRoute(
      path: RouteConstants.vizzleSavedAds,
      name: 'vizzleSavedAds',
      builder: (context, state) => const SavedAdsPage(),
    ),
    GoRoute(
      path: RouteConstants.vizzleFavorites,
      name: 'vizzleFavorites',
      builder: (context, state) => const SavedAdsPage(),
    ),

    // ==================== CATEGORY NAVIGATION ROUTES ====================
    GoRoute(
      path: '${RouteConstants.vizzleCategory}/:categoryName',
      name: 'vizzleCategory',
      builder: (context, state) {
        final categoryName = state.pathParameters['categoryName']!;
        return SubCategoryListingPage(categoryName: categoryName);
      },
    ),
    GoRoute(
      path: '${RouteConstants.vizzleSubCategory}/:categoryName/:subCategoryId',
      name: 'vizzleSubCategory',
      builder: (context, state) {
        final categoryName = state.pathParameters['categoryName']!;
        final subCategoryId = state.pathParameters['subCategoryId']!;
        final queryParams = state.uri.queryParameters;

        return SubSubCategoryPage(
          categoryName: categoryName,
          subCategoryName: queryParams['subCategoryName'] ?? '',
          subCategoryId: subCategoryId,
          categoryId: queryParams['categoryId'] ?? '',
          isFromListAd: queryParams['isFromListAd'] ?? 'false',
        );
      },
    ),
    GoRoute(
      path:
          '${RouteConstants.vizzleSubSubCategory}/:categoryName/:subCategoryId/:subSubCategoryId',
      name: 'vizzleSubSubCategory',
      builder: (context, state) {
        final pathParams = state.pathParameters;
        final queryParams = state.uri.queryParameters;

        return SubSubCategoryPage(
          categoryName: pathParams['categoryName']!,
          subCategoryName: queryParams['subCategoryName'] ?? '',
          subCategoryId: pathParams['subCategoryId']!,
          categoryId: queryParams['categoryId'] ?? '',
          isFromListAd: queryParams['isFromListAd'] ?? 'false',
        );
      },
    ),
    GoRoute(
      path: '${RouteConstants.vizzleSubItems}/:subSubCategoryId',
      name: 'vizzleSubItems',
      builder: (context, state) {
        final subSubCategoryId = state.pathParameters['subSubCategoryId']!;
        final extra = state.extra as Map<String, dynamic>? ?? {};

        return SubItemsPage(
          subSubCategoryId: subSubCategoryId,
          subSubCategoryName: extra['subSubCategoryName'] ?? '',
          categoryName: extra['categoryName'] ?? '',
          subCategoryName: extra['subCategoryName'] ?? '',
          categoryId: extra['categoryId'] ?? '',
          subCategoryId: extra['subCategoryId'] ?? '',
          isFromListAd: extra['isFromListAd'] == true,
          subItems: extra['subItems'] as List<Map<String, dynamic>>?,
        );
      },
    ),

    // ==================== PRODUCT & AD DETAIL ROUTES ====================
    GoRoute(
      path: '${RouteConstants.vizzleProductDetails}/:productId',
      name: 'vizzleProductDetails',
      builder: (context, state) {
        final productId = state.pathParameters['productId']!;
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return Scaffold(
          appBar: AppBar(title: Text('Product $productId')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Product Details: $productId'),
                if (extra['shareUrl'] != null)
                  Text('Share URL: ${extra['shareUrl']}'),
              ],
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: '${RouteConstants.vizzleAdDetails}/:adId',
      name: 'vizzleAdDetails',
      builder: (context, state) {
        final adId = state.pathParameters['adId']!;
        return Scaffold(
          appBar: AppBar(title: Text('Ad $adId')),
          body: Center(child: Text('Ad Details: $adId')),
        );
      },
    ),

    // ==================== SELLER ROUTES ====================
    GoRoute(
      path: '${RouteConstants.vizzleSellerDetails}/:sellerId',
      name: 'vizzleSellerDetails',
      builder: (context, state) {
        final sellerId = state.pathParameters['sellerId']!;
        return SellerDetailsPage(sellerId: sellerId);
      },
    ),
    GoRoute(
      path: '${RouteConstants.vizzleSellerProfile}/:sellerId',
      name: 'vizzleSellerProfile',
      builder: (context, state) {
        final sellerId = state.pathParameters['sellerId']!;
        return SellerDetailsPage(sellerId: sellerId);
      },
    ),
    GoRoute(
      path: '${RouteConstants.vizzleSellerAds}/:sellerId',
      name: 'vizzleSellerAds',
      builder: (context, state) {
        final sellerId = state.pathParameters['sellerId']!;
        return Scaffold(
          appBar: AppBar(title: const Text('Seller Ads')),
          body: Center(child: Text('Seller Ads for: $sellerId')),
        );
      },
    ),
    GoRoute(
      path: '${RouteConstants.vizzleSellerReviews}/:sellerId',
      name: 'vizzleSellerReviews',
      builder: (context, state) {
        final sellerId = state.pathParameters['sellerId']!;
        return Scaffold(
          appBar: AppBar(title: const Text('Seller Reviews')),
          body: Center(child: Text('Reviews for seller: $sellerId')),
        );
      },
    ),
    GoRoute(
      path: '${RouteConstants.vizzleSellerStats}/:sellerId',
      name: 'vizzleSellerStats',
      builder: (context, state) {
        final sellerId = state.pathParameters['sellerId']!;
        return Scaffold(
          appBar: AppBar(title: const Text('Seller Stats')),
          body: Center(child: Text('Stats for seller: $sellerId')),
        );
      },
    ),

    // ==================== AD MANAGEMENT ROUTES ====================
    GoRoute(
      path: RouteConstants.vizzleCreateAd,
      name: 'vizzleCreateAd',
      builder: (context, state) => const CreateAdPage(),
    ),
    GoRoute(
      path: RouteConstants.vizzleEditAd,
      name: 'vizzleEditAd',
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Edit Ad')),
          body: const Center(child: Text('Edit Ad')),
        );
      },
    ),
    GoRoute(
      path: RouteConstants.vizzleMyAds,
      name: 'vizzleMyAds',
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('My Ads')),
          body: const Center(child: Text('Your Ads')),
        );
      },
    ),
    GoRoute(
      path: RouteConstants.vizzleAdPreview,
      name: 'vizzleAdPreview',
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Ad Preview')),
          body: const Center(child: Text('Ad Preview')),
        );
      },
    ),

    // ==================== LEGACY CATEGORY SPECIFIC AD CREATION ====================
    GoRoute(
      path: RouteConstants.vizzleCreateMotorAd,
      name: 'vizzleCreateMotorAd',
      builder: (context, state) => const CreateAdPage(),
    ),
    GoRoute(
      path: RouteConstants.vizzleCreatePropertyAd,
      name: 'vizzleCreatePropertyAd',
      builder: (context, state) => const CreateAdPage(),
    ),
    GoRoute(
      path: RouteConstants.vizzleCreateClassifiedAd,
      name: 'vizzleCreateClassifiedAd',
      builder: (context, state) => const CreateAdPage(),
    ),
    GoRoute(
      path: RouteConstants.vizzleCreateFurnitureAd,
      name: 'vizzleCreateFurnitureAd',
      builder: (context, state) => const CreateAdPage(),
    ),
    GoRoute(
      path: RouteConstants.vizzleCreateJobAd,
      name: 'vizzleCreateJobAd',
      builder: (context, state) => const CreateAdPage(),
    ),

    // ==================== FILTER & SORT ROUTES ====================
    GoRoute(
      path: RouteConstants.vizzleFilters,
      name: 'vizzleFilters',
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Filters')),
          body: const Center(child: Text('Search Filters')),
        );
      },
    ),
    GoRoute(
      path: RouteConstants.vizzleSortOptions,
      name: 'vizzleSortOptions',
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Sort Options')),
          body: const Center(child: Text('Sort Options')),
        );
      },
    ),

    // ==================== VIZZLE PROFILE ROUTES ====================
    GoRoute(
      path: RouteConstants.vizzleProfile,
      name: 'vizzleProfile',
      builder: (context, state) => const VizzleProfilePage(),
    ),
    GoRoute(
      path: RouteConstants.vizzleMyProfile,
      name: 'vizzleMyProfile',
      builder: (context, state) => const VizzleProfilePage(),
    ),

    // ==================== ADDITIONAL REPORT PRODUCT ROUTES ====================
    GoRoute(
      path: '/vizzle/report-product/:productId/:productTitle',
      name: 'reportProductWithPath',
      builder: (context, state) {
        final productId = state.pathParameters['productId']!;
        final productTitle = Uri.decodeComponent(
          state.pathParameters['productTitle']!,
        );

        return ReportProductPage(
          productId: productId,
          productTitle: productTitle,
        );
      },
    ),
    GoRoute(
      path: '/report-product',
      name: 'reportProductQuery',
      builder: (context, state) {
        final productId = state.uri.queryParameters['productId']!;
        final productTitle = state.uri.queryParameters['title']!;
        return ReportProductPage(
          productId: productId,
          productTitle: productTitle,
        );
      },
    ),
  ];

  /// Helper method to build error pages
  static Widget _buildErrorPage(String message) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper methods for route building
  static String buildLocationPickerRoute({
    double? latitude,
    double? longitude,
  }) {
    final params = <String, String>{};
    if (latitude != null) params['lat'] = latitude.toString();
    if (longitude != null) params['lng'] = longitude.toString();

    if (params.isEmpty) return RouteConstants.locationPicker;

    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return '${RouteConstants.locationPicker}?$query';
  }

  static String buildProductDetailRoute({
    required String shareUrl,
    bool isPersonal = false,
  }) {
    final encodedUrl = Uri.encodeComponent(shareUrl);
    return '${RouteConstants.productDetail}?shareUrl=$encodedUrl&isPersonal=$isPersonal';
  }

  static String buildReportProductRoute({
    required String productId,
    required String productTitle,
  }) {
    final encodedTitle = Uri.encodeComponent(productTitle);
    return '${RouteConstants.reportProduct}?productId=$productId&title=$encodedTitle';
  }

  static String buildSearchRoute({
    String? query,
    String? categoryId,
    String? location,
    double? minPrice,
    double? maxPrice,
  }) {
    final queryParams = <String, String>{};

    if (query != null && query.isNotEmpty) {
      queryParams['q'] = Uri.encodeComponent(query);
    }
    if (categoryId != null) queryParams['categoryId'] = categoryId;
    if (location != null) {
      queryParams['location'] = Uri.encodeComponent(location);
    }
    if (minPrice != null) queryParams['minPrice'] = minPrice.toString();
    if (maxPrice != null) queryParams['maxPrice'] = maxPrice.toString();

    if (queryParams.isEmpty) return RouteConstants.vizzleSearch;

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    return '${RouteConstants.vizzleSearch}?$queryString';
  }
}
