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

  bool get isVCartRoute {
    final location = GoRouterState.of(this).uri.toString();
    return location.startsWith(VCartRouterClass.basePath);
  }

  String? get currentVCartRoute {
    final location = GoRouterState.of(this).uri.toString();
    if (!location.startsWith(VCartRouterClass.basePath)) return null;
    return location;
  }
}
