import '../../domain/entities/product_listing_item.dart';

class ProductListingItemModel extends ProductListingItem {
  const ProductListingItemModel({
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
    super.rating,
    super.reviewCount,
    super.isWishlisted,
    super.inStock,
    super.stockCount,
  });

  factory ProductListingItemModel.fromJson(Map<String, dynamic> json) {
    return ProductListingItemModel(
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
      'rating': rating,
      'reviewCount': reviewCount,
      'isWishlisted': isWishlisted,
      'inStock': inStock,
      'stockCount': stockCount,
    };
  }
}
