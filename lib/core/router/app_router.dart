import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
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
// Spin Feature Imports
import '../../features/spin/presentation/pages/daily_spin_page.dart';
import '../../features/spin/presentation/pages/spin_and_earn_page.dart';
import '../../features/spin/presentation/pages/spin_history_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
// Vizzle Feature Imports
import '../../features/vhub/presentation/pages/vhub_home_page.dart';
import '../../features/vhub/presentation/widgets/create_idea/create_idea_page.dart';
import '../../features/vhub/presentation/widgets/faq/faq_page.dart';
import '../../features/vhub/presentation/widgets/ideas/idea_details_page.dart';
import '../../features/vhub/presentation/widgets/ideas/ideas_page.dart';
import '../../features/vizzle/ads_listing/presentation/pages/ads_listing_page.dart';
import '../../features/vizzle/edit_ad/presentation/pages/edit_ad_page.dart';
import '../../features/vizzle/home/presentation/pages/vizzle_home_page.dart';
import '../../features/vizzle/place_add/presentation/pages/create_ad_page.dart';
import '../../features/vizzle/place_add/presentation/pages/location_picker_page.dart';
import '../../features/vizzle/place_add/presentation/pages/select_category_page.dart';
import '../../features/vizzle/place_add/presentation/pages/select_city_page.dart';
import '../../features/vizzle/place_add/presentation/pages/select_subcategory_page.dart';
import '../../features/vizzle/product_detail/presentation/pages/product_detail_page.dart';
import '../../features/vizzle/product_detail/presentation/pages/report_product_page.dart';
import '../../features/vizzle/profile/presentation/pages/vizzle_profile_page.dart';
import '../../features/vizzle/recently_viewed/presentation/pages/recently_viewed_page.dart';
import '../../features/vizzle/saved_view/presentation/pages/saved_ads_page.dart';
import '../../features/vizzle/search/presentation/pages/search_page.dart';
import '../../features/vizzle/seller_details/presentation/pages/seller_details_page.dart';
import '../../features/vizzle/sub_category_listing/presentation/pages/sub_category_listing_page.dart';
import '../../features/vizzle/sub_items_view/presentation/pages/sub_items_page.dart';
import '../../features/vizzle/sub_sub_category_list_view/presentation/pages/sub_sub_category_page.dart';
import '../constants/app_constants.dart';
import '../constants/route_constants.dart';
import '../widgets/navigation/bottom_navigation.dart';
import 'route_helper.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteConstants.splash,
    redirect: RouteHelper.redirect,
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

      // ==================== SPIN GAME ROUTES ====================
      GoRoute(
        path: RouteConstants.dailySpin,
        builder: (context, state) => const DailySpinPage(),
      ),
      GoRoute(
        path: RouteConstants.spinAndWin,
        builder: (context, state) => const SpinAndEarnPage(),
      ),
      GoRoute(
        path: RouteConstants.spinHistory,
        builder: (context, state) => const SpinHistoryPage(),
      ),

      // ==================== PLACE ADD FLOW ROUTES ====================
      GoRoute(
        path: RouteConstants.selectCity,
        builder: (context, state) => const SelectCityPage(),
      ),
      GoRoute(
        path: RouteConstants.selectCategory,
        builder: (context, state) => const SelectCategoryPage(),
      ),
      GoRoute(
        path: RouteConstants.selectSubCategory,
        builder: (context, state) => const SelectSubCategoryPage(),
      ),
      GoRoute(
        path: RouteConstants.createAd,
        builder: (context, state) => const CreateAdPage(),
      ),
      GoRoute(
        path: RouteConstants.locationPicker,
        builder: (context, state) {
          final queryParams = state.uri.queryParameters;
          return LocationPickerPage(
            initialLatitude: double.tryParse(queryParams['lat'] ?? ''),
            initialLongitude: double.tryParse(queryParams['lng'] ?? ''),
          );
        },
      ),

      // ========== EDIT AD ROUTES ==========
      GoRoute(
        path: '${RouteConstants.editAd}/:adId',
        builder: (context, state) {
          final adId = state.pathParameters['adId'];

          if (adId == null || adId.isEmpty) {
            return const Scaffold(
              backgroundColor: AppConstants.black,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'Invalid ad ID',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          }

          return EditAdPage(adId: adId);
        },
      ),

      // ========== CATEGORY SPECIFIC CREATE AD ROUTES ==========
      GoRoute(
        path: RouteConstants.createMotorAd,
        builder: (context, state) => const CreateAdPage(),
      ),
      GoRoute(
        path: RouteConstants.createPropertyAd,
        builder: (context, state) => const CreateAdPage(),
      ),
      GoRoute(
        path: RouteConstants.createElectronicsAd,
        builder: (context, state) => const CreateAdPage(),
      ),
      GoRoute(
        path: RouteConstants.createFurnitureAd,
        builder: (context, state) => const CreateAdPage(),
      ),
      GoRoute(
        path: RouteConstants.createFarmFreshAd,
        builder: (context, state) => const CreateAdPage(),
      ),
      GoRoute(
        path: RouteConstants.createCommunityAd,
        builder: (context, state) => const CreateAdPage(),
      ),

      // ========== PRODUCT DETAIL ROUTES ==========
      GoRoute(
        path: RouteConstants.productDetail,
        builder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final shareUrl = queryParams['shareUrl'];
          final isPersonal = queryParams['isPersonal'] == 'true';

          if (shareUrl == null || shareUrl.isEmpty) {
            return const Scaffold(
              backgroundColor: AppConstants.black,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'Invalid product URL',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          }

          return ProductDetailPage(shareUrl: shareUrl, isPersonal: isPersonal);
        },
      ),
      GoRoute(
        path: RouteConstants.reportProduct,
        builder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final productId = queryParams['productId'];
          final productTitle = queryParams['title'] ?? 'Product';

          if (productId == null || productId.isEmpty) {
            return const Scaffold(
              backgroundColor: AppConstants.black,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'Invalid product ID',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          }

          return ReportProductPage(
            productId: productId,
            productTitle: productTitle,
          );
        },
      ),

      // ========== SEARCH ROUTES ==========
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

      // ========== ADS LISTING ROUTES ==========
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

      // ========== USER CONTENT ROUTES ==========
      GoRoute(
        path: RouteConstants.vizzleRecentlyViewed,
        builder: (context, state) => const RecentlyViewedPage(),
      ),
      GoRoute(
        path: RouteConstants.vizzleSavedAds,
        builder: (context, state) => const SavedAdsPage(),
      ),
      GoRoute(
        path: RouteConstants.vizzleFavorites,
        builder: (context, state) => const SavedAdsPage(),
      ),

      // ========== CATEGORY NAVIGATION ROUTES ==========
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

      // ========== PRODUCT & AD DETAIL ROUTES ==========
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

      // ========== SELLER ROUTES ==========
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

      // ========== AD MANAGEMENT ROUTES ==========
      GoRoute(
        path: RouteConstants.vizzleCreateAd,
        builder: (context, state) => const CreateAdPage(),
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

      // ========== LEGACY CATEGORY SPECIFIC AD CREATION ==========
      GoRoute(
        path: RouteConstants.vizzleCreateMotorAd,
        builder: (context, state) => const CreateAdPage(),
      ),
      GoRoute(
        path: RouteConstants.vizzleCreatePropertyAd,
        builder: (context, state) => const CreateAdPage(),
      ),
      GoRoute(
        path: RouteConstants.vizzleCreateClassifiedAd,
        builder: (context, state) => const CreateAdPage(),
      ),
      GoRoute(
        path: RouteConstants.vizzleCreateFurnitureAd,
        builder: (context, state) => const CreateAdPage(),
      ),
      GoRoute(
        path: RouteConstants.vizzleCreateJobAd,
        builder: (context, state) => const CreateAdPage(),
      ),

      // ========== FILTER & SORT ROUTES ==========
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

      // ==================== STANDALONE PAGES ====================

      // ========== COUPONS ==========
      GoRoute(
        path: RouteConstants.coupons,
        builder: (context, state) => const CouponHomePage(),
      ),

      // ========== REDEMPTION ==========
      GoRoute(
        path: RouteConstants.walletRecharge,
        builder: (context, state) => const WalletRechargePage(),
      ),

      // ========== PROFILE PAGES ==========
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

      // ========== ADDITIONAL REPORT PRODUCT ROUTES ==========
      GoRoute(
        path: '/vizzle/report-product/:productId/:productTitle',
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
        builder: (context, state) {
          final productId = state.uri.queryParameters['productId']!;
          final productTitle = state.uri.queryParameters['title']!;
          return ReportProductPage(
            productId: productId,
            productTitle: productTitle,
          );
        },
      ),
      // ========== VIZZLE PROFILE ROUTES ==========
      GoRoute(
        path: RouteConstants.vizzleProfile,
        builder: (context, state) => const VizzleProfilePage(),
      ),
      GoRoute(
        path: RouteConstants.vizzleMyProfile,
        builder: (context, state) => const VizzleProfilePage(),
      ),

      // ========== SPIN ROUTES ==========
      GoRoute(
        path: RouteConstants.spinHistory,
        builder: (context, state) => const SpinHistoryPage(),
      ),

      // ==================== VHUB BUSINESS STARTUP ROUTES ====================
      GoRoute(
        path: RouteConstants.vhubHome,
        builder: (context, state) => const VHubHomePage(),
      ),
      GoRoute(
        path: RouteConstants.vhubIdeas,
        builder: (context, state) => const IdeasPage(),
      ),
      GoRoute(
        path: RouteConstants.vhubCreateIdea,
        builder: (context, state) => const CreateIdeaPage(),
      ),
      GoRoute(
        path: RouteConstants.vhubFaq,
        builder: (context, state) => const FaqPage(),
      ),

      GoRoute(
        path: '${RouteConstants.vhubIdeaDetails}/:ideaId',
        builder: (context, state) {
          final ideaId = state.pathParameters['ideaId']!;
          return IdeaDetailsPage(ideaId: ideaId);
        },
      ),
    ],
  );
}
