import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../cart/domain/entities/cart_data.dart';
import 'vcart_router.dart';

extension VCartRouterExtensions on BuildContext {
  /// Navigate to checkout with cart data
  void goToVCartCheckout(CartData cartData) {
    push(VCartRouterClass.checkout, extra: cartData);
  }

  /// Navigate to address list
  void goToVCartAddressList() {
    push(VCartRouterClass.addressList);
  }

  /// Navigate to add address form
  void goToVCartAddAddress() {
    push(VCartRouterClass.addAddress);
  }

  /// Navigate to edit address form
  void goToVCartEditAddress(String addressId) {
    push('${VCartRouterClass.editAddress}/$addressId');
  }

  /// Navigate to order success page
  void goToVCartOrderSuccess(String orderId) {
    push('${VCartRouterClass.orderSuccess}/$orderId');
  }

  /// Push checkout page
  Future<T?> pushVCartCheckout<T extends Object?>(CartData cartData) {
    return push<T>(VCartRouterClass.checkout, extra: cartData);
  }

  /// Push address list page
  Future<T?> pushVCartAddressList<T extends Object?>() {
    return push<T>(VCartRouterClass.addressList);
  }

  /// Push add address form
  Future<T?> pushVCartAddAddress<T extends Object?>() {
    return push<T>(VCartRouterClass.addAddress);
  }

  /// Push edit address form
  Future<T?> pushVCartEditAddress<T extends Object?>(String addressId) {
    return push<T>('${VCartRouterClass.editAddress}/$addressId');
  }

  /// Navigate to VCart home
  void goToVCartHome() {
    go(VCartRouterClass.home);
  }

  /// Navigate to VCart cart
  void goToVCartCart() {
    push(VCartRouterClass.cart);
  }

  /// Navigate to VCart product
  void goToVCartProduct(String productId) {
    push('${VCartRouterClass.productDetail}/$productId');
  }

  /// Navigate to VCart wishlist
  void goToVCartWishlist() {
    push(VCartRouterClass.wishlist);
  }

  /// Navigate to VCart coupons
  void goToVCartCoupons() {
    push(VCartRouterClass.coupons);
  }

  /// Navigate to VCart categories
  void goToVCartCategories() {
    push(VCartRouterClass.categories);
  }

  /// Navigate to VCart search
  void goToVCartSearch() {
    push(VCartRouterClass.search);
  }

  /// Navigate to VCart profile
  void goToVCartProfile() {
    push(VCartRouterClass.profile);
  }

  /// Check if current route is VCart route
  bool get isVCartRoute {
    final location = GoRouterState.of(this).uri.toString();
    return location.startsWith(VCartRouterClass.basePath);
  }

  /// Get current VCart route
  String? get currentVCartRoute {
    final location = GoRouterState.of(this).uri.toString();
    if (!location.startsWith(VCartRouterClass.basePath)) return null;
    return location;
  }
}
