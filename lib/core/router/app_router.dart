import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/coupons/presentation/pages/coupon_home_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/about_app_page.dart';
import '../../features/profile/presentation/pages/change_password_page.dart';
import '../../features/profile/presentation/pages/contact_us_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/help_support_page.dart';
import '../../features/profile/presentation/pages/loyalty_points_page.dart';
import '../../features/profile/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/pages/privacy_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/terms_conditions_page.dart';
import '../../features/promos/presentation/pages/promos_page.dart';
import '../../features/redemption/presentation/pages/redemption_page.dart';
import '../../features/redemption/presentation/pages/wallet_recharge_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
// Vizzle Feature Imports
import '../../features/vizzle/ads_listing/presentation/pages/ads_listing_page.dart';
import '../../features/vizzle/home/presentation/pages/vizzle_home_page.dart';
import '../../features/vizzle/recently_viewed/presentation/pages/recently_viewed_page.dart';
import '../../features/vizzle/saved_view/presentation/pages/saved_ads_page.dart';
import '../../features/vizzle/search/presentation/pages/search_page.dart';
import '../../features/vizzle/seller_details/presentation/pages/seller_details_page.dart';
import '../../features/vizzle/sub_category_listing/presentation/pages/sub_category_listing_page.dart';
import '../../features/vizzle/sub_items_view/presentation/pages/sub_items_page.dart';
import '../../features/vizzle/sub_sub_category_list_view/presentation/pages/sub_sub_category_page.dart';
import '../constants/route_constants.dart';
import '../widgets/navigation/bottom_navigation.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteConstants.splash,
    redirect: _redirect,
    routes: [
      // ==================== SPLASH ROUTE ====================
      GoRoute(
        path: RouteConstants.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // ==================== AUTH ROUTES ====================
      GoRoute(
        path: RouteConstants.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteConstants.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteConstants.otpVerification,
        builder: (context, state) => OtpVerificationPage(
          email: state.uri.queryParameters['email'] ?? '',
          isLogin: state.uri.queryParameters['isLogin'] == 'true',
        ),
      ),

      // ==================== VIZZLE MARKETPLACE ROUTES ====================

      // Vizzle Search Routes
      GoRoute(
        path: RouteConstants.vizzleSearch,
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
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: RouteConstants.vizzleSearchFilters,
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: RouteConstants.vizzleSearchHistory,
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: RouteConstants.vizzleSearchSuggestions,
        builder: (context, state) => const SearchPage(),
      ),

      // Vizzle Category Navigation Routes
      GoRoute(
        path: '${RouteConstants.vizzleCategory}/:categoryName',
        builder: (context, state) {
          final categoryName = state.pathParameters['categoryName']!;
          return SubCategoryListingPage(categoryName: categoryName);
        },
      ),

      GoRoute(
        path:
            '${RouteConstants.vizzleSubCategory}/:categoryName/:subCategoryId',
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
        builder: (context, state) {
          final subSubCategoryId = state.pathParameters['subSubCategoryId']!;
          final queryParams = state.uri.queryParameters;

          return SubItemsPage(
            subSubCategoryId: subSubCategoryId,
            subSubCategoryName: queryParams['subSubCategoryName'] ?? '',
            categoryName: queryParams['categoryName'] ?? '',
            subCategoryName: queryParams['subCategoryName'] ?? '',
            categoryId: queryParams['categoryId'] ?? '',
            subCategoryId: queryParams['subCategoryId'] ?? '',
            isFromListAd: queryParams['isFromListAd'] == 'true',
          );
        },
      ),

      // Vizzle Ads & Product Routes
      GoRoute(
        path: RouteConstants.vizzleAdsListing,
        builder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final extra = state.extra as Map<String, dynamic>? ?? {};

          // Merge query parameters and extra data
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

      GoRoute(
        path: '${RouteConstants.vizzleProductDetails}/:productId',
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
        builder: (context, state) {
          final adId = state.pathParameters['adId']!;
          return Scaffold(
            appBar: AppBar(title: Text('Ad $adId')),
            body: Center(child: Text('Ad Details: $adId')),
          );
        },
      ),

      // Vizzle Seller Routes
      GoRoute(
        path: '${RouteConstants.vizzleSellerDetails}/:sellerId',
        builder: (context, state) {
          final sellerId = state.pathParameters['sellerId']!;
          return SellerDetailsPage(sellerId: sellerId);
        },
      ),

      GoRoute(
        path: '${RouteConstants.vizzleSellerProfile}/:sellerId',
        builder: (context, state) {
          final sellerId = state.pathParameters['sellerId']!;
          return SellerDetailsPage(sellerId: sellerId);
        },
      ),

      GoRoute(
        path: '${RouteConstants.vizzleSellerAds}/:sellerId',
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
        builder: (context, state) {
          final sellerId = state.pathParameters['sellerId']!;
          return Scaffold(
            appBar: AppBar(title: const Text('Seller Stats')),
            body: Center(child: Text('Stats for seller: $sellerId')),
          );
        },
      ),

      // Vizzle User Content Routes
      GoRoute(
        path: RouteConstants.vizzleFavorites,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Favorites')),
            body: const Center(child: Text('Your Favorite Ads')),
          );
        },
      ),

      GoRoute(
        path: RouteConstants.vizzleRecentlyViewed,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Recently Viewed')),
            body: const Center(child: Text('Recently Viewed Ads')),
          );
        },
      ),

      GoRoute(
        path: RouteConstants.vizzleSavedAds,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Saved Ads')),
            body: const Center(child: Text('Your Saved Ads')),
          );
        },
      ),

      // Vizzle Ad Management Routes (Future Implementation)
      GoRoute(
        path: RouteConstants.vizzleCreateAd,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Create Ad')),
            body: const Center(child: Text('Create New Ad')),
          );
        },
      ),

      GoRoute(
        path: RouteConstants.vizzleEditAd,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Edit Ad')),
            body: const Center(child: Text('Edit Ad')),
          );
        },
      ),

      GoRoute(
        path: RouteConstants.vizzleMyAds,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('My Ads')),
            body: const Center(child: Text('Your Ads')),
          );
        },
      ),

      GoRoute(
        path: RouteConstants.vizzleAdPreview,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Ad Preview')),
            body: const Center(child: Text('Ad Preview')),
          );
        },
      ),

      GoRoute(
        path: RouteConstants.vizzleCreateMotorAd,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Create Motor Ad')),
            body: const Center(child: Text('Create Motor Advertisement')),
          );
        },
      ),

      GoRoute(
        path: RouteConstants.vizzleCreatePropertyAd,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Create Property Ad')),
            body: const Center(child: Text('Create Property Advertisement')),
          );
        },
      ),

      GoRoute(
        path: RouteConstants.vizzleCreateClassifiedAd,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Create Classified Ad')),
            body: const Center(child: Text('Create Classified Advertisement')),
          );
        },
      ),

      GoRoute(
        path: RouteConstants.vizzleCreateFurnitureAd,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Create Furniture Ad')),
            body: const Center(child: Text('Create Furniture Advertisement')),
          );
        },
      ),

      GoRoute(
        path: RouteConstants.vizzleCreateJobAd,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Create Job Ad')),
            body: const Center(child: Text('Create Job Advertisement')),
          );
        },
      ),

      // Vizzle Filter & Sort Routes
      GoRoute(
        path: RouteConstants.vizzleFilters,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Filters')),
            body: const Center(child: Text('Search Filters')),
          );
        },
      ),

      GoRoute(
        path: RouteConstants.vizzleSortOptions,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Sort Options')),
            body: const Center(child: Text('Sort Options')),
          );
        },
      ),

      // Vizzle User Content Routes (update existing ones)
      GoRoute(
        path: RouteConstants.vizzleFavorites,
        builder: (context, state) => const SavedAdsPage(),
      ),

      GoRoute(
        path: RouteConstants.vizzleRecentlyViewed,
        builder: (context, state) => const RecentlyViewedPage(),
      ),

      GoRoute(
        path: RouteConstants.vizzleSavedAds,
        builder: (context, state) => const SavedAdsPage(),
      ),

      // ==================== STANDALONE PAGES ====================

      // Coupons
      GoRoute(
        path: RouteConstants.coupons,
        builder: (context, state) => const CouponHomePage(),
      ),

      // Redemption
      GoRoute(
        path: RouteConstants.walletRecharge,
        builder: (context, state) => const WalletRechargePage(),
      ),

      // Profile Pages
      GoRoute(
        path: RouteConstants.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: RouteConstants.loyaltyPoints,
        builder: (context, state) => const LoyaltyPointsPage(),
      ),
      GoRoute(
        path: RouteConstants.changePassword,
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: RouteConstants.notifications,
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: RouteConstants.privacy,
        builder: (context, state) => const PrivacyPage(),
      ),
      GoRoute(
        path: RouteConstants.termsConditions,
        builder: (context, state) => const TermsConditionsPage(),
      ),
      GoRoute(
        path: RouteConstants.aboutApp,
        builder: (context, state) => const AboutAppPage(),
      ),
      GoRoute(
        path: RouteConstants.helpSupport,
        builder: (context, state) => const HelpSupportPage(),
      ),
      GoRoute(
        path: RouteConstants.contactUs,
        builder: (context, state) => const ContactUsPage(),
      ),

      // ==================== MAIN APP WITH BOTTOM NAVIGATION ====================
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => BottomNavigation(child: child),
        routes: [
          GoRoute(
            path: RouteConstants.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: RouteConstants.promos,
            builder: (context, state) => const PromosPage(),
          ),
          GoRoute(
            path: RouteConstants.redemption,
            builder: (context, state) => const RedemptionPage(),
          ),
          GoRoute(
            path: RouteConstants.profile,
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: RouteConstants.vizzleHome,
            builder: (context, state) => const VizzleHomePage(),
          ),
        ],
      ),
    ],
  );

  // ==================== NAVIGATION REDIRECT LOGIC ====================
  static String? _redirect(BuildContext context, GoRouterState state) {
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

  // ==================== UTILITY METHODS ====================

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

  /// Navigate to product details with product ID
  static void navigateToProductDetails(
    BuildContext context,
    String productId, {
    String? shareUrl,
  }) {
    final extra = shareUrl != null ? {'shareUrl': shareUrl} : null;
    context.push(RouteConstants.productDetailsWithId(productId), extra: extra);
  }

  /// Navigate to search with parameters
  static void navigateToSearch(
    BuildContext context, {
    String? keyword,
    String? categoryId,
    String? location,
    double? minPrice,
    double? maxPrice,
  }) {
    final route = RouteConstants.searchWithQuery(
      keyword: keyword,
      categoryId: categoryId,
      location: location,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
    context.push(route);
  }

  /// Navigate to ads listing with filters
  static void navigateToAdsListing(
    BuildContext context, {
    String? categoryId,
    String? subCategoryId,
    String? categoryName,
    String? subCategoryName,
    String? keyword,
    double? minPrice,
    double? maxPrice,
    String? location,
    String? sortBy,
  }) {
    final route = RouteConstants.adsListingWithFilters(
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      categoryName: categoryName,
      subCategoryName: subCategoryName,
      keyword: keyword,
      minPrice: minPrice,
      maxPrice: maxPrice,
      location: location,
      sortBy: sortBy,
    );
    context.push(route);
  }

  /// Check if current route is a Vizzle route
  static bool isCurrentRouteVizzle(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return RouteConstants.isVizzleRoute(location);
  }

  /// Get current route category for analytics
  static String getCurrentRouteCategory(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return RouteConstants.getRouteCategory(location);
  }
}
