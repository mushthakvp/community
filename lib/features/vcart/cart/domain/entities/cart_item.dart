import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String productId;
  final String sizeId;
  final String name;
  final List<String> images;
  final String size;
  final double price;
  final double offerPrice;
  final double tax;
  final int quantity;
  final int availableStock;
  final bool isAvailable;
  final String? message;
  final double couponDiscount;
  final double commission;

  const CartItem({
    required this.productId,
    required this.sizeId,
    required this.name,
    required this.images,
    required this.size,
    required this.price,
    required this.offerPrice,
    required this.tax,
    required this.quantity,
    required this.availableStock,
    required this.isAvailable,
    this.message,
    required this.couponDiscount,
    required this.commission,
  });

  double get finalPrice => price + commission;
  double get finalOfferPrice => offerPrice + commission;
  bool get hasDiscount => offerPrice < price;
  double get totalPrice => finalOfferPrice * quantity;
  String get primaryImage => images.isNotEmpty ? images.first : '';

  CartItem copyWith({
    String? productId,
    String? sizeId,
    String? name,
    List<String>? images,
    String? size,
    double? price,
    double? offerPrice,
    double? tax,
    int? quantity,
    int? availableStock,
    bool? isAvailable,
    String? message,
    double? couponDiscount,
    double? commission,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      sizeId: sizeId ?? this.sizeId,
      name: name ?? this.name,
      images: images ?? this.images,
      size: size ?? this.size,
      price: price ?? this.price,
      offerPrice: offerPrice ?? this.offerPrice,
      tax: tax ?? this.tax,
      quantity: quantity ?? this.quantity,
      availableStock: availableStock ?? this.availableStock,
      isAvailable: isAvailable ?? this.isAvailable,
      message: message ?? this.message,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      commission: commission ?? this.commission,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    sizeId,
    name,
    images,
    size,
    price,
    offerPrice,
    tax,
    quantity,
    availableStock,
    isAvailable,
    message,
    couponDiscount,
    commission,
  ];
}
