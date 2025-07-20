import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.productId,
    required super.sizeId,
    required super.name,
    required super.images,
    required super.size,
    required super.price,
    required super.offerPrice,
    required super.tax,
    required super.quantity,
    required super.availableStock,
    required super.isAvailable,
    super.message,
    required super.couponDiscount,
    required super.commission,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] ?? '',
      sizeId: json['sizeId'] ?? '',
      name: json['name'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      size: json['size'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      offerPrice: (json['offerPrice'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      availableStock: json['availableStock'] ?? 0,
      isAvailable: json['isAvailable'] ?? false,
      message: json['message'],
      couponDiscount: (json['couponDiscount'] ?? 0).toDouble(),
      commission: (json['commission'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'sizeId': sizeId,
      'name': name,
      'images': images,
      'size': size,
      'price': price,
      'offerPrice': offerPrice,
      'tax': tax,
      'quantity': quantity,
      'availableStock': availableStock,
      'isAvailable': isAvailable,
      'message': message,
      'couponDiscount': couponDiscount,
      'commission': commission,
    };
  }
}
