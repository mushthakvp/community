import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../constants/route_constants.dart';
import 'routers/auth_router.dart';
import 'routers/profile_router.dart';
import 'routers/spin_router.dart';
import 'routers/vhub_router.dart';
import 'routers/vizzle_router.dart';
import 'routers/vjob_router.dart';

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

  // ==================== AUTH NAVIGATION HELPER METHODS ====================

  /// Navigate to login page
  static void navigateToLogin(BuildContext context) {
    context.push(AuthRouter.loginPath);
  }

  /// Navigate to register page
  static void navigateToRegister(BuildContext context) {
    context.push(AuthRouter.registerPath);
  }

  /// Navigate to OTP verification
  static void navigateToOtpVerification(
    BuildContext context, {
    required String email,
    required bool isLogin,
  }) {
    final route = AuthRouter.buildOtpRoute(email: email, isLogin: isLogin);
    context.push(route);
  }

  // ==================== VHUB NAVIGATION HELPER METHODS ====================

  /// Navigate to VHub home
  static void navigateToVHub(BuildContext context) {
    context.push(VHubRouter.vhubHomePath);
  }

  /// Navigate to VHub ideas
  static void navigateToVHubIdeas(BuildContext context) {
    context.push(VHubRouter.vhubIdeasPath);
  }

  /// Navigate to VHub create idea
  static void navigateToVHubCreateIdea(BuildContext context) {
    context.push(VHubRouter.vhubCreateIdeaPath);
  }

  /// Navigate to VHub FAQ
  static void navigateToVHubFaq(BuildContext context) {
    context.push(VHubRouter.vhubFaqPath);
  }

  /// Navigate to VHub idea details
  static void navigateToVHubIdeaDetails(BuildContext context, String ideaId) {
    context.push(VHubRouter.buildIdeaDetailsRoute(ideaId));
  }

  /// Navigate to VHub edit idea
  static void navigateToVHubEditIdea(BuildContext context, String ideaId) {
    context.push(VHubRouter.buildEditIdeaRoute(ideaId));
  }

  // ==================== SPIN GAME NAVIGATION HELPER METHODS ====================

  /// Navigate to spin games main
  static void navigateToSpinGames(BuildContext context) {
    context.push(SpinRouter.spinMainPath);
  }

  /// Navigate to daily spin
  static void navigateToDailySpin(BuildContext context) {
    context.push(SpinRouter.dailySpinPath);
  }

  /// Navigate to spin and win
  static void navigateToSpinAndWin(BuildContext context) {
    context.push(SpinRouter.spinAndWinPath);
  }

  /// Navigate to spin history
  static void navigateToSpinHistory(BuildContext context) {
    context.push(SpinRouter.spinHistoryPath);
  }

  // ==================== VIZZLE NAVIGATION HELPER METHODS ====================

  /// Navigate to Vizzle home
  static void navigateToVizzleHome(BuildContext context) {
    context.push(RouteConstants.vizzleHome);
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
    final route = VizzleRouter.buildProductDetailRoute(
      shareUrl: shareUrl,
      isPersonal: isPersonal,
    );
    context.push(route);
  }

  /// Navigate to report product
  static void navigateToReportProduct(
    BuildContext context,
    String productId,
    String productTitle,
  ) {
    final route = VizzleRouter.buildReportProductRoute(
      productId: productId,
      productTitle: productTitle,
    );
    context.push(route);
  }

  /// Navigate to ads listing
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
    final route = VizzleRouter.buildSearchRoute(
      query: query,
      categoryId: categoryId,
      location: location,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
    context.push(route);
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

  /// Navigate to location picker
  static void navigateToLocationPicker(
    BuildContext context, {
    double? latitude,
    double? longitude,
  }) {
    final route = VizzleRouter.buildLocationPickerRoute(
      latitude: latitude,
      longitude: longitude,
    );
    context.push(route);
  }

  // ==================== VJOB NAVIGATION HELPER METHODS ====================

  /// Navigate to VJob home
  static void navigateToVJob(BuildContext context) {
    context.push(VJobRouter.vjobHomePath);
  }

  /// Navigate to VJob job details
  static void navigateToVJobJobDetails(BuildContext context, String jobId) {
    context.push(VJobRouter.buildJobDetailsRoute(jobId));
  }

  /// Navigate to VJob create job
  static void navigateToVJobCreateJob(BuildContext context) {
    context.push(VJobRouter.vjobCreateJobPath);
  }

  /// Navigate to VJob my jobs
  static void navigateToVJobMyJobs(BuildContext context) {
    context.push(VJobRouter.vjobMyJobsPath);
  }

  /// Navigate to VJob applications
  static void navigateToVJobApplications(BuildContext context) {
    context.push(VJobRouter.vjobApplicationsPath);
  }

  /// Navigate to VJob saved jobs
  static void navigateToVJobSavedJobs(BuildContext context) {
    context.push(VJobRouter.vjobSavedJobsPath);
  }

  /// Navigate to VJob search with optional parameters
  static void navigateToVJobSearch(
    BuildContext context, {
    String? query,
    String? location,
    String? workStyle,
  }) {
    final route = VJobRouter.buildJobSearchRoute(
      query: query,
      location: location,
      workStyle: workStyle,
    );
    context.push(route);
  }

  /// Navigate to VJob companies
  static void navigateToVJobCompanies(BuildContext context) {
    context.push(VJobRouter.vjobCompaniesPath);
  }

  /// Navigate to VJob create company
  static void navigateToVJobCreateCompany(BuildContext context) {
    context.push(VJobRouter.vjobCreateCompanyPath);
  }

  /// Navigate to VJob posts
  static void navigateToVJobPosts(BuildContext context) {
    context.push(VJobRouter.vjobPostsPath);
  }

  /// Navigate to VJob create post
  static void navigateToVJobCreatePost(BuildContext context) {
    context.push(VJobRouter.vjobCreatePostPath);
  }

  // ==================== PROFILE NAVIGATION HELPER METHODS ====================

  /// Navigate to edit profile
  static void navigateToEditProfile(BuildContext context) {
    context.push(ProfileRouter.editProfilePath);
  }

  /// Navigate to loyalty points
  static void navigateToLoyaltyPoints(BuildContext context) {
    context.push(ProfileRouter.loyaltyPointsPath);
  }

  /// Navigate to change password
  static void navigateToChangePassword(BuildContext context) {
    context.push(ProfileRouter.changePasswordPath);
  }

  /// Navigate to notifications
  static void navigateToNotifications(BuildContext context) {
    context.push(ProfileRouter.notificationsPath);
  }

  /// Navigate to privacy policy
  static void navigateToPrivacy(BuildContext context) {
    context.push(ProfileRouter.privacyPath);
  }

  /// Navigate to terms and conditions
  static void navigateToTermsConditions(BuildContext context) {
    context.push(ProfileRouter.termsConditionsPath);
  }

  /// Navigate to about app
  static void navigateToAboutApp(BuildContext context) {
    context.push(ProfileRouter.aboutAppPath);
  }

  /// Navigate to help and support
  static void navigateToHelpSupport(BuildContext context) {
    context.push(ProfileRouter.helpSupportPath);
  }

  /// Navigate to contact us
  static void navigateToContactUs(BuildContext context) {
    context.push(ProfileRouter.contactUsPath);
  }

  /// Navigate to coupons
  static void navigateToCoupons(BuildContext context) {
    context.push(ProfileRouter.couponsPath);
  }

  /// Navigate to wallet recharge
  static void navigateToWalletRecharge(BuildContext context) {
    context.push(ProfileRouter.walletRechargePath);
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

  /// Check if current route is a VJob route
  static bool isCurrentRouteVJob(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return RouteConstants.isVJobRoute(location);
  }

  /// Check if current route is an Auth route
  static bool isCurrentRouteAuth(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return RouteConstants.isAuthRoute(location);
  }

  /// Check if current route is a Profile route
  static bool isCurrentRouteProfile(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return ProfileRouter.isProfileManagementRoute(location) ||
        ProfileRouter.isLegalInformationRoute(location) ||
        ProfileRouter.isSupportRoute(location) ||
        ProfileRouter.isRewardsRoute(location);
  }

  /// Get current route category for analytics
  static String getCurrentRouteCategory(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return RouteConstants.getRouteCategory(location);
  }

  // ==================== NAVIGATION STATE HELPERS ====================

  /// Check if can go back
  static bool canPop(BuildContext context) {
    return GoRouter.of(context).canPop();
  }

  /// Go back if possible
  static void goBack(BuildContext context) {
    if (canPop(context)) {
      context.pop();
    }
  }

  /// Go to root and replace with new route
  static void goAndClearStack(BuildContext context, String route) {
    context.go(route);
  }

  /// Push and remove all previous routes
  static void pushAndClearStack(BuildContext context, String route) {
    // Clear the stack by going to the route
    context.go(route);
  }

  // ==================== UTILITY METHODS ====================

  /// Get current route path
  static String getCurrentRoute(BuildContext context) {
    return GoRouterState.of(context).uri.toString();
  }

  /// Get current route name
  static String? getCurrentRouteName(BuildContext context) {
    return GoRouterState.of(context).name;
  }

  /// Check if current route matches pattern
  static bool isCurrentRoute(BuildContext context, String pattern) {
    final currentRoute = getCurrentRoute(context);
    return currentRoute == pattern || currentRoute.startsWith(pattern);
  }

  /// Build query string from parameters
  static String buildQueryString(Map<String, String> parameters) {
    if (parameters.isEmpty) return '';

    final encodedParams = parameters.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '?$encodedParams';
  }

  /// Parse query parameters from URL
  static Map<String, String> parseQueryParameters(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters;
  }
}
