import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.images,
    required super.price,
    required super.offerPrice,
    required super.commission,
    required super.isActive,
    required super.categoryId,
    required super.brandId,
    super.specifications,
    super.rating,
    super.reviewCount,
    super.isWishlisted,
    super.inStock,
    super.stockCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      price: (json['price'] ?? 0).toDouble(),
      offerPrice: (json['offerPrice'] ?? 0).toDouble(),
      commission: (json['commission'] ?? 0).toDouble(),
      isActive: json['isActive'] ?? true,
      categoryId: json['categoryId'] ?? '',
      brandId: json['brandId'] ?? '',
      specifications: json['specifications'],
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      isWishlisted: json['isWishlisted'] ?? false,
      inStock: json['inStock'] ?? true,
      stockCount: json['stockCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'images': images,
      'price': price,
      'offerPrice': offerPrice,
      'commission': commission,
      'isActive': isActive,
      'categoryId': categoryId,
      'brandId': brandId,
      'specifications': specifications,
      'rating': rating,
      'reviewCount': reviewCount,
      'isWishlisted': isWishlisted,
      'inStock': inStock,
      'stockCount': stockCount,
    };
  }
}
