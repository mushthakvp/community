import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../cart/presentation/pages/cart_page.dart';
import '../../categories/presentation/pages/categories_page.dart';
import '../../coupons/presentation/pages/coupons_page.dart';
import '../../filter_page/presentation/pages/filter_page.dart';
import '../../home/presentation/pages/home_page.dart';
import '../../navigation/presentation/pages/main_navigation_page.dart';
import '../../product_listing/presentation/pages/product_listing_page.dart';
import '../../product_overview/presentation/pages/product_overview_page.dart';
import '../../profile/presentation/pages/profile_page.dart';
import '../../search/presentation/pages/search_page.dart';
import '../../section_category/presentation/pages/section_category_page.dart';
import '../../wishlist/presentation/pages/wishlist_page.dart';

class VCartRouterClass {
  static const String _basePath = '/vcart';
  static get basePath => _basePath;

  // Route paths
  static const String home = '$_basePath/home';
  static const String search = '$_basePath/search';
  static const String categories = '$_basePath/categories';
  static const String category = '$_basePath/category';
  static const String sectionCategory = '$_basePath/section-category';
  static const String productListing = '$_basePath/product-listing';
  static const String productDetail = '$_basePath/product';
  static const String filter = '$_basePath/filter';
  static const String profile = '$_basePath/profile';
  static const String cart = '$_basePath/cart';
  static const String wishlist = '$_basePath/wishlist';
  static const String coupons = '$_basePath/coupons';

  // Main pages for navigation
  static final List<Widget> _mainPages = [
    const VCartHomePage(),
    const VCartCategoriesPage(),
    const VCartCartPage(),
    const VCartProfilePage(),
  ];

  // All VCart routes
  static List<RouteBase> get routes => [
    GoRoute(path: _basePath, redirect: (context, state) => home),
    GoRoute(
      path: home,
      name: 'vcart-home',
      builder: (context, state) => VCartMainNavigationPage(
        pages: _mainPages,
        onMarketplaceTap: () {
          context.go('/home');
        },
      ),
    ),
    GoRoute(
      path: search,
      name: 'vcart-search',
      builder: (context, state) => const VCartSearchPage(),
    ),
    GoRoute(
      path: categories,
      name: 'vcart-categories',
      builder: (context, state) => const VCartCategoriesPage(),
    ),
    GoRoute(
      path: category,
      name: 'vcart-category',
      builder: (context, state) {
        return VCartCategoriesPage();
      },
    ),
    GoRoute(
      path: '$sectionCategory/:sectionId',
      name: 'vcart-section-category',
      builder: (context, state) {
        final sectionId = state.pathParameters['sectionId']!;
        final title = state.uri.queryParameters['title'] ?? 'Section';
        return VCartSectionCategoryPage(sectionId: sectionId, title: title);
      },
    ),
    GoRoute(
      path: productListing,
      name: 'vcart-product-listing',
      builder: (context, state) {
        final queryParams = state.uri.queryParameters;
        return VCartProductListingPage(
          title: queryParams['title'] ?? 'Products',
          sectionId: queryParams['sectionId'],
          categoryId: queryParams['categoryId'],
          subCategoryId: queryParams['subCategoryId'],
          brandId: queryParams['brandId'],
        );
      },
    ),
    GoRoute(
      path: '$productDetail/:productId',
      name: 'vcart-product-detail',
      builder: (context, state) {
        final productId = state.pathParameters['productId']!;
        return VCartProductOverviewPage(productId: productId);
      },
    ),
    GoRoute(
      path: filter,
      name: 'vcart-filter',
      builder: (context, state) {
        final queryParams = state.uri.queryParameters;
        return VCartFilterPage(
          sectionId: queryParams['sectionId'],
          brandId: queryParams['brandId'],
        );
      },
    ),
    GoRoute(
      path: profile,
      name: 'vcart-profile',
      builder: (context, state) => const VCartProfilePage(),
    ),
    GoRoute(
      path: cart,
      name: 'vcart-cart',
      builder: (context, state) => const VCartCartPage(showBackButton: true),
    ),
    GoRoute(
      path: wishlist,
      name: 'vcart-wishlist',
      builder: (context, state) => const VCartWishlistPage(),
    ),
    GoRoute(
      path: coupons,
      name: 'vcart-coupons',
      builder: (context, state) => const VCartCouponsPage(),
    ),
  ];
}
