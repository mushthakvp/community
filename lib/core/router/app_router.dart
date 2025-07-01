// lib/core/router/app_router.dart
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
import '../../features/vizzle/ads_listing/presentation/pages/ads_listing_page.dart';
import '../../features/vizzle/home/presentation/pages/vizzle_home_page.dart';
// NEW IMPORTS FOR SELLER DETAILS & SEARCH
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
      // Splash route
      GoRoute(
        path: RouteConstants.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // Auth routes (without bottom navigation)
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

      // Seller Details Main Route
      GoRoute(
        path: '${RouteConstants.vizzleSellerDetails}/:sellerId',
        builder: (context, state) {
          final sellerId = state.pathParameters['sellerId']!;
          return SellerDetailsPage(sellerId: sellerId);
        },
      ),

      // Advanced Search Route
      GoRoute(
        path: RouteConstants.vizzleAdvancedSearch,
        builder: (context, state) => const SearchPage(),
      ),

      // Vizzle sub-pages (without bottom navigation)
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
          final subCategoryName =
              state.uri.queryParameters['subCategoryName'] ?? '';
          final categoryId = state.uri.queryParameters['categoryId'] ?? '';
          final isFromListAd =
              state.uri.queryParameters['isFromListAd'] ?? 'false';

          return SubSubCategoryPage(
            categoryName: categoryName,
            subCategoryName: subCategoryName,
            subCategoryId: subCategoryId,
            categoryId: categoryId,
            isFromListAd: isFromListAd,
          );
        },
      ),
      GoRoute(
        path: '${RouteConstants.vizzleSubItems}/:subSubCategoryId',
        builder: (context, state) {
          final subSubCategoryId = state.pathParameters['subSubCategoryId']!;
          final subSubCategoryName =
              state.uri.queryParameters['subSubCategoryName'] ?? '';
          final categoryName = state.uri.queryParameters['categoryName'] ?? '';
          final subCategoryName =
              state.uri.queryParameters['subCategoryName'] ?? '';
          final categoryId = state.uri.queryParameters['categoryId'] ?? '';
          final subCategoryId =
              state.uri.queryParameters['subCategoryId'] ?? '';
          final isFromListAd =
              state.uri.queryParameters['isFromListAd'] == 'true';

          return SubItemsPage(
            subSubCategoryId: subSubCategoryId,
            subSubCategoryName: subSubCategoryName,
            categoryName: categoryName,
            subCategoryName: subCategoryName,
            categoryId: categoryId,
            subCategoryId: subCategoryId,
            isFromListAd: isFromListAd,
          );
        },
      ),

      // Vizzle Ads Listing Route
      GoRoute(
        path: RouteConstants.vizzleAdsListing,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};

          return AdsListingPage(
            categoryId: extra['categoryId'],
            subCategoryId: extra['subCategoryId'],
            categoryName: extra['categoryName'],
            subCategoryName: extra['subCategoryName'],
            initialFilter: extra['initialFilter'],
          );
        },
      ),

      // Standalone pages (without bottom navigation)
      GoRoute(
        path: RouteConstants.coupons,
        builder: (context, state) => const CouponHomePage(),
      ),

      // Redemption standalone pages
      GoRoute(
        path: RouteConstants.walletRecharge,
        builder: (context, state) => const WalletRechargePage(),
      ),

      // Profile standalone pages (without bottom navigation)
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

      // Main app with bottom navigation (including Vizzle home)
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
          // Add Vizzle home to bottom navigation
          GoRoute(
            path: RouteConstants.vizzleHome,
            builder: (context, state) => const VizzleHomePage(),
          ),
        ],
      ),
    ],
  );

  static String? _redirect(BuildContext context, GoRouterState state) {
    final location = state.uri.toString();
    if (location == RouteConstants.splash) {
      return null;
    }
    final authProvider = context.read<AuthProvider>();
    if (!authProvider.isAuthenticated &&
        RouteConstants.isProtectedRoute(location)) {
      return RouteConstants.login;
    }
    if (authProvider.isAuthenticated && RouteConstants.isAuthRoute(location)) {
      return RouteConstants.home;
    }
    return null;
  }
}
