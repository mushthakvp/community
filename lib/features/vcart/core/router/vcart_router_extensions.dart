import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../cart/domain/entities/cart_data.dart';

extension VCartRouterExtensions on BuildContext {
  /// Navigate to checkout with cart data
  void goToCheckout(CartData cartData) {
    go('/checkout', extra: cartData);
  }

  /// Navigate to address list
  void goToAddressList() {
    go('/address');
  }

  /// Navigate to add address form
  void goToAddAddress() {
    go('/address/add');
  }

  /// Navigate to edit address form
  void goToEditAddress(String addressId) {
    go('/address/edit/$addressId');
  }

  /// Navigate to order success page
  void goToOrderSuccess(String orderId) {
    go('/order-success/$orderId');
  }

  /// Push checkout page
  Future<T?> pushCheckout<T extends Object?>(CartData cartData) {
    return push<T>('/checkout', extra: cartData);
  }

  /// Push address list page
  Future<T?> pushAddressList<T extends Object?>() {
    return push<T>('/address');
  }

  /// Push add address form
  Future<T?> pushAddAddress<T extends Object?>() {
    return push<T>('/address/add');
  }

  /// Push edit address form
  Future<T?> pushEditAddress<T extends Object?>(String addressId) {
    return push<T>('/address/edit/$addressId');
  }
}
