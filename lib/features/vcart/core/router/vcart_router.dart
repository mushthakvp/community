import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../cart/presentation/pages/cart_page.dart';
import '../../categories/presentation/pages/categories_page.dart';
import '../../filter_page/presentation/pages/filter_page.dart';
import '../../home/presentation/pages/home_page.dart';
import '../../navigation/presentation/pages/main_navigation_page.dart';
import '../../product_listing/presentation/pages/product_listing_page.dart';
import '../../product_overview/presentation/pages/product_overview_page.dart';
import '../../profile/presentation/pages/profile_page.dart';
import '../../search/presentation/pages/search_page.dart';
import '../../section_category/presentation/pages/section_category_page.dart';
import '../../wishlist/presentation/pages/wishlist_page.dart';

class VCartRouter {
  static const String _basePath = '/vcart';
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

  static final List<Widget> _mainPages = [
    const VCartHomePage(),
    const VCartCategoriesPage(),
    const VCartCartPage(),
    const VCartProfilePage(),
  ];

  static List<RouteBase> get routes => [
    GoRoute(path: _basePath, redirect: (context, state) => home),
    GoRoute(
      path: home,
      name: 'vcart-home',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: VCartMainNavigationPage(
          pages: _mainPages,
          onMarketplaceTap: () {
            context.go('/home');
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: search,
      name: 'vcart-search',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const VCartSearchPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: categories,
      name: 'vcart-categories',
      builder: (context, state) => const VCartCategoriesPage(),
    ),
    GoRoute(
      path: '$category/:categoryId',
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
      pageBuilder: (context, state) {
        final productId = state.pathParameters['productId']!;
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: VCartProductOverviewPage(productId: productId),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
        );
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
      builder: (context, state) => const VCartCartPage(),
    ),
    GoRoute(
      path: wishlist,
      name: 'vcart-wishlist',
      builder: (context, state) => const VCartWishlistPage(),
    ),
  ];
}
