import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../constants/route_constants.dart';

class RouteHelper {
  // ==================== NAVIGATION REDIRECT LOGIC ====================
  static String? redirect(BuildContext context, GoRouterState state) {
    final location = state.uri.toString();

    // Allow splash screen
    if (location == RouteConstants.splash) {
      return null;
    }

    final authProvider = context.read<AuthProvider>();

    // Redirect to login if not authenticated and accessing protected route
    if (!authProvider.isAuthenticated &&
        RouteConstants.isProtectedRoute(location)) {
      return RouteConstants.login;
    }

    // Redirect to home if authenticated and accessing auth route
    if (authProvider.isAuthenticated && RouteConstants.isAuthRoute(location)) {
      return RouteConstants.home;
    }

    return null;
  }

  // ==================== NAVIGATION HELPER METHODS ====================

  /// Navigate to VHub home
  static void navigateToVHub(BuildContext context) {
    context.push(RouteConstants.vhubHome);
  }

  /// Navigate to VHub ideas
  static void navigateToVHubIdeas(BuildContext context) {
    context.push(RouteConstants.vhubIdeas);
  }

  /// Navigate to VHub create idea
  static void navigateToVHubCreateIdea(BuildContext context) {
    context.push(RouteConstants.vhubCreateIdea);
  }

  /// Navigate to VHub FAQ
  static void navigateToVHubFaq(BuildContext context) {
    context.push(RouteConstants.vhubFaq);
  }

  /// Navigate to VHub idea details
  static void navigateToVHubIdeaDetails(BuildContext context, String ideaId) {
    context.push(RouteConstants.vhubIdeaDetailsWithId(ideaId));
  }

  /// Navigate to spin games
  static void navigateToSpinGames(BuildContext context) {
    context.push(RouteConstants.spinMain);
  }

  /// Navigate to daily spin
  static void navigateToDailySpin(BuildContext context) {
    context.push(RouteConstants.dailySpin);
  }

  /// Navigate to spin and win
  static void navigateToSpinAndWin(BuildContext context) {
    context.push(RouteConstants.spinAndWin);
  }

  /// Navigate to spin history
  static void navigateToSpinHistory(BuildContext context) {
    context.push(RouteConstants.spinHistory);
  }

  /// Navigate to create ad flow
  static void navigateToCreateAd(BuildContext context) {
    context.push(RouteConstants.selectCity);
  }

  /// Navigate to edit ad page
  static void navigateToEditAd(BuildContext context, String adId) {
    context.push(RouteConstants.editAdWithIdRoute(adId));
  }

  /// Navigate to product details with share URL
  static void navigateToProductDetail(
    BuildContext context,
    String shareUrl, {
    bool isPersonal = false,
  }) {
    final encodedUrl = Uri.encodeComponent(shareUrl);
    context.push(
      '${RouteConstants.productDetail}?shareUrl=$encodedUrl&isPersonal=$isPersonal',
    );
  }

  /// Navigate to report product
  static void navigateToReportProduct(
    BuildContext context,
    String productId,
    String productTitle,
  ) {
    final encodedTitle = Uri.encodeComponent(productTitle);
    context.push(
      '${RouteConstants.reportProduct}?productId=$productId&title=$encodedTitle',
    );
  }

  static void navigateToAdsListing(
    BuildContext context, {
    String? categoryId,
    String? subCategoryId,
    String? subSubCategoryId,
    String? subItemId,
    String? categoryName,
    String? subCategoryName,
    String? subSubCategoryName,
    String? subItemName,
    Map<String, dynamic>? initialFilter,
  }) {
    final extra = <String, dynamic>{};

    if (categoryId != null) extra['categoryId'] = categoryId;
    if (subCategoryId != null) extra['subCategoryId'] = subCategoryId;
    if (subSubCategoryId != null) extra['subSubCategoryId'] = subSubCategoryId;
    if (subItemId != null) extra['subItemId'] = subItemId;
    if (categoryName != null) extra['categoryName'] = categoryName;
    if (subCategoryName != null) extra['subCategoryName'] = subCategoryName;
    if (subSubCategoryName != null) {
      extra['subSubCategoryName'] = subSubCategoryName;
    }
    if (subItemName != null) extra['subItemName'] = subItemName;
    if (initialFilter != null) extra['initialFilter'] = initialFilter;

    context.push(RouteConstants.vizzleAdsListing, extra: extra);
  }

  /// Navigate to search with query
  static void navigateToSearch(
    BuildContext context, {
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

    String route = RouteConstants.vizzleSearch;
    if (queryParams.isNotEmpty) {
      final queryString = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      route += '?$queryString';
    }

    context.push(route);
  }

  // ==================== LEGACY UTILITY METHODS ====================

  /// Navigate to a specific route with optional parameters
  static void navigateTo(
    BuildContext context,
    String route, {
    Map<String, String>? pathParameters,
    Map<String, String>? queryParameters,
    Object? extra,
  }) {
    String finalRoute = route;

    // Replace path parameters
    if (pathParameters != null) {
      pathParameters.forEach((key, value) {
        finalRoute = finalRoute.replaceAll(':$key', value);
      });
    }

    // Add query parameters
    if (queryParameters != null && queryParameters.isNotEmpty) {
      final query = queryParameters.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      finalRoute += '?$query';
    }

    if (extra != null) {
      context.push(finalRoute, extra: extra);
    } else {
      context.push(finalRoute);
    }
  }

  /// Navigate to seller details with seller ID
  static void navigateToSellerDetails(BuildContext context, String sellerId) {
    context.push(RouteConstants.sellerDetailsWithId(sellerId));
  }

  /// Navigate to product details with product ID (legacy method)
  static void navigateToProductDetails(
    BuildContext context,
    String productId, {
    String? shareUrl,
  }) {
    final extra = shareUrl != null ? {'shareUrl': shareUrl} : null;
    context.push(RouteConstants.productDetailsWithId(productId), extra: extra);
  }

  // ==================== ROUTE ANALYSIS METHODS ====================

  /// Check if current route is a Vizzle route
  static bool isCurrentRouteVizzle(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return RouteConstants.isVizzleRoute(location);
  }

  /// Check if current route is a VHub route
  static bool isCurrentRouteVHub(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return RouteConstants.isVHubRoute(location);
  }

  /// Check if current route is a Spin route
  static bool isCurrentRouteSpin(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return RouteConstants.isSpinRoute(location);
  }

  /// Get current route category for analytics
  static String getCurrentRouteCategory(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return RouteConstants.getRouteCategory(location);
  }
}
