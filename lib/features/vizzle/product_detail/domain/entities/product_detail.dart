class ProductDetail {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currencyCode;
  final List<String> images;
  final ProductUser user;
  final ProductCategory? category;
  final ProductCategory? subCategory;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? age;
  final String? usage;
  final String? condition;
  final String? sellerType;
  final String? brand;
  final String? model;
  final String? color;
  final String? shareLink;
  final DateTime createdAt;
  final bool isSaved;
  final bool isCurrentUser;
  final List<RelatedProduct> relatedProducts;

  const ProductDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currencyCode,
    required this.images,
    required this.user,
    this.category,
    this.subCategory,
    this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.age,
    this.usage,
    this.condition,
    this.sellerType,
    this.brand,
    this.model,
    this.color,
    this.shareLink,
    required this.createdAt,
    required this.isSaved,
    required this.isCurrentUser,
    required this.relatedProducts,
  });
}

class ProductUser {
  final String id;
  final String name;
  final String? profileImage;

  const ProductUser({required this.id, required this.name, this.profileImage});
}

class ProductCategory {
  final String id;
  final String name;

  const ProductCategory({required this.id, required this.name});
}

class RelatedProduct {
  final String id;
  final String title;
  final double price;
  final List<String> images;
  final String? brand;
  final String? shareLink;
  final bool isSaved;

  const RelatedProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.images,
    this.brand,
    this.shareLink,
    required this.isSaved,
  });
}
