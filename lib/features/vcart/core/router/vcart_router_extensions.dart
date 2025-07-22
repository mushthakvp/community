import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../cart/domain/entities/cart_data.dart';
import 'vcart_router.dart';

extension VCartRouterExtensions on BuildContext {
  void goToVCartCheckout(CartData cartData) {
    push(VCartRouterClass.checkout, extra: cartData);
  }

  void goToVCartAddressList() {
    push(VCartRouterClass.addressList);
  }

  void goToVCartAddAddress() {
    push(VCartRouterClass.addAddress);
  }

  void goToVCartEditAddress(String addressId) {
    push('${VCartRouterClass.editAddress}/$addressId');
  }

  void goToVCartOrderSuccess(String orderId) {
    push('${VCartRouterClass.orderSuccess}/$orderId');
  }

  void goToVCartOrderHistory() {
    push(VCartRouterClass.orderHistory);
  }

  void goToVCartOrderDetails(String orderId) {
    push('${VCartRouterClass.orderDetails}/$orderId');
  }

  void goToVCartOrderTracking(String orderId) {
    push('${VCartRouterClass.orderTracking}/$orderId');
  }

  Future<T?> pushVCartCheckout<T extends Object?>(CartData cartData) {
    return push<T>(VCartRouterClass.checkout, extra: cartData);
  }

  Future<T?> pushVCartAddressList<T extends Object?>() {
    return push<T>(VCartRouterClass.addressList);
  }

  Future<T?> pushVCartAddAddress<T extends Object?>() {
    return push<T>(VCartRouterClass.addAddress);
  }

  Future<T?> pushVCartEditAddress<T extends Object?>(String addressId) {
    return push<T>('${VCartRouterClass.editAddress}/$addressId');
  }

  Future<T?> pushVCartOrderHistory<T extends Object?>() {
    return push<T>(VCartRouterClass.orderHistory);
  }

  Future<T?> pushVCartOrderDetails<T extends Object?>(String orderId) {
    return push<T>('${VCartRouterClass.orderDetails}/$orderId');
  }

  Future<T?> pushVCartOrderTracking<T extends Object?>(String orderId) {
    return push<T>('${VCartRouterClass.orderTracking}/$orderId');
  }

  void goToVCartHome() {
    go(VCartRouterClass.home);
  }

  void goToVCartCart() {
    push(VCartRouterClass.cart);
  }

  void goToVCartProduct(String productId) {
    push('${VCartRouterClass.productDetail}/$productId');
  }

  void goToVCartWishlist() {
    push(VCartRouterClass.wishlist);
  }

  void goToVCartCoupons() {
    push(VCartRouterClass.coupons);
  }

  void goToVCartCategories() {
    push(VCartRouterClass.categories);
  }

  void goToVCartSearch() {
    push(VCartRouterClass.search);
  }

  void goToVCartProfile() {
    push(VCartRouterClass.profile);
  }

  void goToVCartProductListing({
    required String title,
    String? sectionId,
    String? categoryId,
    String? subCategoryId,
    String? brandId,
  }) {
    final queryParams = <String, String>{'title': title};
    if (sectionId != null) queryParams['sectionId'] = sectionId;
    if (categoryId != null) queryParams['categoryId'] = categoryId;
    if (subCategoryId != null) queryParams['subCategoryId'] = subCategoryId;
    if (brandId != null) queryParams['brandId'] = brandId;

    final uri = Uri(
      path: VCartRouterClass.productListing,
      queryParameters: queryParams,
    );
    push(uri.toString());
  }

  void goToVCartSectionCategory(String sectionId, {String? title}) {
    final uri = Uri(
      path: '${VCartRouterClass.sectionCategory}/$sectionId',
      queryParameters: title != null ? {'title': title} : null,
    );
    push(uri.toString());
  }

  void goToVCartFilter({String? sectionId, String? brandId}) {
    final queryParams = <String, String>{};
    if (sectionId != null) queryParams['sectionId'] = sectionId;
    if (brandId != null) queryParams['brandId'] = brandId;

    final uri = Uri(
      path: VCartRouterClass.filter,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    push(uri.toString());
  }

  Future<T?> pushVCartProduct<T extends Object?>(String productId) {
    return push<T>('${VCartRouterClass.productDetail}/$productId');
  }

  Future<T?> pushVCartCoupons<T extends Object?>() {
    return push<T>(VCartRouterClass.coupons);
  }

  Future<T?> pushVCartSearch<T extends Object?>() {
    return push<T>(VCartRouterClass.search);
  }

  Future<T?> pushVCartFilter<T extends Object?>({
    String? sectionId,
    String? brandId,
  }) {
    final queryParams = <String, String>{};
    if (sectionId != null) queryParams['sectionId'] = sectionId;
    if (brandId != null) queryParams['brandId'] = brandId;

    final uri = Uri(
      path: VCartRouterClass.filter,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return push<T>(uri.toString());
  }

  bool get isVCartRoute {
    final location = GoRouterState.of(this).uri.toString();
    return location.startsWith(VCartRouterClass.basePath);
  }

  String? get currentVCartRoute {
    final location = GoRouterState.of(this).uri.toString();
    if (!location.startsWith(VCartRouterClass.basePath)) return null;
    return location;
  }

  bool get isVCartOrderHistoryRoute {
    final location = GoRouterState.of(this).uri.toString();
    return location.startsWith(VCartRouterClass.orderHistory);
  }

  bool get isVCartOrderDetailsRoute {
    final location = GoRouterState.of(this).uri.toString();
    return location.contains('/order-details/');
  }

  bool get isVCartCheckoutRoute {
    final location = GoRouterState.of(this).uri.toString();
    return location.startsWith(VCartRouterClass.checkout);
  }

  String? get currentOrderId {
    final location = GoRouterState.of(this).uri.toString();
    if (location.contains('/order-details/')) {
      final segments = location.split('/');
      final orderDetailsIndex = segments.indexOf('order-details');
      if (orderDetailsIndex != -1 && orderDetailsIndex + 1 < segments.length) {
        return segments[orderDetailsIndex + 1];
      }
    }
    return null;
  }

  void backInVCart() {
    if (canPop()) {
      pop();
    } else {
      goToVCartHome();
    }
  }

  void replaceWithVCartHome() {
    go(VCartRouterClass.home);
  }

  void replaceWithVCartOrderHistory() {
    go(VCartRouterClass.orderHistory);
  }
}
