import 'package:equatable/equatable.dart';

import 'cart_item.dart';
import 'coupon_data.dart';

class CartData extends Equatable {
  final bool success;
  final String message;
  final List<CartItem> items;
  final double subTotal;
  final double offerPrice;
  final double commission;
  final double shippingCharge;
  final double tax;
  final double discount;
  final double couponDiscount;
  final double total;
  final double walletAmount;
  final CouponData? couponData;

  const CartData({
    required this.success,
    required this.message,
    required this.items,
    required this.subTotal,
    required this.offerPrice,
    required this.commission,
    required this.shippingCharge,
    required this.tax,
    required this.discount,
    required this.couponDiscount,
    required this.total,
    required this.walletAmount,
    this.couponData,
  });

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  bool get hasCoupon => couponData != null;
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get finalSubTotal => subTotal + commission;
  double get finalTotal => total;
  double get totalSavings => discount + couponDiscount;

  @override
  List<Object?> get props => [
    success,
    message,
    items,
    subTotal,
    offerPrice,
    commission,
    shippingCharge,
    tax,
    discount,
    couponDiscount,
    total,
    walletAmount,
    couponData,
  ];
}
