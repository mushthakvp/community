import 'package:equatable/equatable.dart';

class ProductSize extends Equatable {
  final String id;
  final String size;
  final double price;
  final double offerPrice;
  final int quantity;
  final double weight;
  final String weightUnit;
  final double offerPercentage;
  final bool isAddedCart;

  const ProductSize({
    required this.id,
    required this.size,
    required this.price,
    required this.offerPrice,
    required this.quantity,
    required this.weight,
    required this.weightUnit,
    required this.offerPercentage,
    required this.isAddedCart,
  });

  ProductSize copyWith({
    String? id,
    String? size,
    double? price,
    double? offerPrice,
    int? quantity,
    double? weight,
    String? weightUnit,
    double? offerPercentage,
    bool? isAddedCart,
  }) {
    return ProductSize(
      id: id ?? this.id,
      size: size ?? this.size,
      price: price ?? this.price,
      offerPrice: offerPrice ?? this.offerPrice,
      quantity: quantity ?? this.quantity,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      offerPercentage: offerPercentage ?? this.offerPercentage,
      isAddedCart: isAddedCart ?? this.isAddedCart,
    );
  }

  @override
  List<Object?> get props => [
    id,
    size,
    price,
    offerPrice,
    quantity,
    weight,
    weightUnit,
    offerPercentage,
    isAddedCart,
  ];
}
