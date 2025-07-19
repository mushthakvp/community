import '../../domain/entities/product_size.dart';

class ProductSizeModel extends ProductSize {
  const ProductSizeModel({
    required super.id,
    required super.size,
    required super.price,
    required super.offerPrice,
    required super.quantity,
    required super.weight,
    required super.weightUnit,
    required super.offerPercentage,
    required super.isAddedCart,
  });

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) {
    return ProductSizeModel(
      id: json['_id'] ?? '',
      size: json['size'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      offerPrice: (json['offerPrice'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      weight: (json['weight'] ?? 0).toDouble(),
      weightUnit: json['weightUnit'] ?? '',
      offerPercentage: (json['offerPercentage'] ?? 0).toDouble(),
      isAddedCart: json['isAddedCart'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'size': size,
      'price': price,
      'offerPrice': offerPrice,
      'quantity': quantity,
      'weight': weight,
      'weightUnit': weightUnit,
      'offerPercentage': offerPercentage,
      'isAddedCart': isAddedCart,
    };
  }
}
