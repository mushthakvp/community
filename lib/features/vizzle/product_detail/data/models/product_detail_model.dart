import '../../domain/entities/product_detail.dart';

class ProductDetailModel extends ProductDetail {
  const ProductDetailModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.currencyCode,
    required super.images,
    required super.user,
    super.category,
    super.subCategory,
    super.address,
    super.latitude,
    super.longitude,
    super.phone,
    super.age,
    super.usage,
    super.condition,
    super.sellerType,
    super.brand,
    super.model,
    super.color,
    super.shareLink,
    required super.createdAt,
    required super.isSaved,
    required super.isCurrentUser,
    required super.relatedProducts,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    final ad = json['ad'] as Map<String, dynamic>? ?? {};

    return ProductDetailModel(
      id: ad['_id'] ?? '',
      title: ad['title'] ?? '',
      description: ad['description'] ?? '',
      price: (ad['price'] ?? 0).toDouble(),
      currencyCode: json['currencyCode'] ?? '',
      images: List<String>.from(ad['images'] ?? []),
      user: ProductUserModel.fromJson(ad['userId'] ?? {}),
      category: ad['category'] != null
          ? ProductCategoryModel.fromJson(ad['category'])
          : null,
      subCategory: ad['subCategory'] != null
          ? ProductCategoryModel.fromJson(ad['subCategory'])
          : null,
      address: ad['address'],
      latitude: double.tryParse(ad['latitude']?.toString() ?? ''),
      longitude: double.tryParse(ad['longitude']?.toString() ?? ''),
      phone: ad['phone'],
      age: ad['age'],
      usage: ad['usage'],
      condition: ad['condition'],
      sellerType: ad['sellerType'],
      brand: ad['brand'],
      model: ad['model'],
      color: ad['color'],
      shareLink: ad['shareLink'],
      createdAt: DateTime.tryParse(ad['createdAt'] ?? '') ?? DateTime.now(),
      isSaved: ad['isSaved'] ?? false,
      isCurrentUser: json['currentUser'] ?? false,
      relatedProducts:
          (json['relatedAds'] as List<dynamic>?)
              ?.map((item) => RelatedProductModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class ProductUserModel extends ProductUser {
  const ProductUserModel({
    required super.id,
    required super.name,
    super.profileImage,
  });

  factory ProductUserModel.fromJson(Map<String, dynamic> json) {
    return ProductUserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
    );
  }
}

class ProductCategoryModel extends ProductCategory {
  const ProductCategoryModel({required super.id, required super.name});

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class RelatedProductModel extends RelatedProduct {
  const RelatedProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.images,
    super.brand,
    super.shareLink,
    required super.isSaved,
  });

  factory RelatedProductModel.fromJson(Map<String, dynamic> json) {
    return RelatedProductModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      brand: json['brand'],
      shareLink: json['shareLink'],
      isSaved: json['isSaved'] ?? false,
    );
  }
}
