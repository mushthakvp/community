import '../../domain/entities/cart_data.dart';
import 'cart_item_model.dart';
import 'coupon_data_model.dart';

class CartDataModel extends CartData {
  const CartDataModel({
    required super.success,
    required super.message,
    required super.items,
    required super.subTotal,
    required super.offerPrice,
    required super.commission,
    required super.shippingCharge,
    required super.tax,
    required super.discount,
    required super.couponDiscount,
    required super.total,
    required super.walletAmount,
    super.couponData,
  });

  factory CartDataModel.fromJson(Map<String, dynamic> json) {
    return CartDataModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      items:
          (json['cart'] as List<dynamic>?)
              ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      subTotal: (json['subTotal'] ?? 0).toDouble(),
      offerPrice: (json['offerPrice'] ?? 0).toDouble(),
      commission: (json['commission'] ?? 0).toDouble(),
      shippingCharge: (json['shippingCharge'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      couponDiscount: (json['couponDiscount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      walletAmount: (json['walletAmount'] ?? 0).toDouble(),
      couponData: json['couponData'] != null
          ? CouponDataModel.fromJson(json['couponData'])
          : null,
    );
  }
}
