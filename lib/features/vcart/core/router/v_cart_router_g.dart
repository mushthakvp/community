import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'vcart_router.dart';

class VCartRouterClassG {
  static bool _isInVCartContext = false;
  static bool _hasNavigatedFromVCart = false;

  // Navigation state getters
  static bool get isInVCartContext => _isInVCartContext;
  static bool get hasNavigatedFromVCart => _hasNavigatedFromVCart;

  // Set navigation context
  static void setVCartContext(bool inContext) {
    _isInVCartContext = inContext;
  }

  static void resetNavigationFlags() {
    _hasNavigatedFromVCart = false;
  }

  // Get current context
  static BuildContext _getContext() {
    final context = navigatorKey.currentContext;
    if (context == null) {
      throw Exception('No context available for navigation');
    }
    return context;
  }

  // Navigator key for accessing context
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Set navigation state
  static void _setNavigatingFromVCart() {
    _hasNavigatedFromVCart = true;
    _isInVCartContext = true;
  }

  // Navigation methods
  static void toVCartHome() {
    _setNavigatingFromVCart();
    GoRouter.of(_getContext()).go(VCartRouterClass.home);
  }

  static void toVCartSearch() {
    _setNavigatingFromVCart();
    GoRouter.of(_getContext()).go(VCartRouterClass.search);
  }

  static void toVCartCategories() {
    _setNavigatingFromVCart();
    GoRouter.of(_getContext()).go(VCartRouterClass.categories);
  }

  static void toVCartCategory(String categoryId, {String? title}) {
    _setNavigatingFromVCart();
    final uri = Uri(
      path: '${VCartRouterClass.category}/$categoryId',
      queryParameters: title != null ? {'title': title} : null,
    );
    GoRouter.of(_getContext()).go(uri.toString());
  }

  static void toVCartSectionCategory(String sectionId, {String? title}) {
    _setNavigatingFromVCart();
    final uri = Uri(
      path: '${VCartRouterClass.sectionCategory}/$sectionId',
      queryParameters: title != null ? {'title': title} : null,
    );
    GoRouter.of(_getContext()).go(uri.toString());
  }

  static void toVCartProductListing({
    required String title,
    String? sectionId,
    String? categoryId,
    String? subCategoryId,
    String? brandId,
  }) {
    _setNavigatingFromVCart();
    final queryParams = <String, String>{'title': title};
    if (sectionId != null) queryParams['sectionId'] = sectionId;
    if (categoryId != null) queryParams['categoryId'] = categoryId;
    if (subCategoryId != null) queryParams['subCategoryId'] = subCategoryId;
    if (brandId != null) queryParams['brandId'] = brandId;

    final uri = Uri(
      path: VCartRouterClass.productListing,
      queryParameters: queryParams,
    );
    GoRouter.of(_getContext()).go(uri.toString());
  }

  static void toVCartProduct(String productId) {
    _setNavigatingFromVCart();
    GoRouter.of(
      _getContext(),
    ).go('${VCartRouterClass.productDetail}/$productId');
  }

  static void toVCartFilter({String? sectionId, String? brandId}) {
    _setNavigatingFromVCart();
    final queryParams = <String, String>{};
    if (sectionId != null) queryParams['sectionId'] = sectionId;
    if (brandId != null) queryParams['brandId'] = brandId;

    final uri = Uri(
      path: VCartRouterClass.filter,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    GoRouter.of(_getContext()).go(uri.toString());
  }

  static void toVCartProfile() {
    _setNavigatingFromVCart();
    GoRouter.of(_getContext()).go(VCartRouterClass.profile);
  }

  static void toVCartCart() {
    _setNavigatingFromVCart();
    GoRouter.of(_getContext()).go(VCartRouterClass.cart);
  }

  static void toVCartWishlist() {
    _setNavigatingFromVCart();
    GoRouter.of(_getContext()).go(VCartRouterClass.wishlist);
  }

  static void toVCartCoupons() {
    _setNavigatingFromVCart();
    GoRouter.of(_getContext()).go(VCartRouterClass.coupons);
  }

  // Push methods (for modal/dialog navigation)
  static Future<T?> pushVCartSearch<T>() {
    _setNavigatingFromVCart();
    return GoRouter.of(_getContext()).push(VCartRouterClass.search);
  }

  static Future<T?> pushVCartProduct<T>(String productId) {
    _setNavigatingFromVCart();
    return GoRouter.of(
      _getContext(),
    ).push('${VCartRouterClass.productDetail}/$productId');
  }

  static Future<T?> pushVCartFilter<T>({String? sectionId, String? brandId}) {
    _setNavigatingFromVCart();
    final queryParams = <String, String>{};
    if (sectionId != null) queryParams['sectionId'] = sectionId;
    if (brandId != null) queryParams['brandId'] = brandId;

    final uri = Uri(
      path: VCartRouterClass.filter,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return GoRouter.of(_getContext()).push(uri.toString());
  }

  static Future<T?> pushVCartCoupons<T>() {
    _setNavigatingFromVCart();
    return GoRouter.of(_getContext()).push(VCartRouterClass.coupons);
  }

  // Back navigation
  static void backInVCart() {
    final context = _getContext();
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    } else {
      // If can't pop, go to VCart home
      toVCartHome();
    }
  }

  // Check if current route is VCart route
  static bool isVCartRoute(String location) {
    return location.startsWith(VCartRouterClass.basePath);
  }

  // Get current VCart route name
  static String? getCurrentVCartRoute() {
    final context = navigatorKey.currentContext;
    if (context == null) return null;

    final location = GoRouterState.of(context).uri.toString();
    if (!isVCartRoute(location)) return null;

    return location;
  }
}
