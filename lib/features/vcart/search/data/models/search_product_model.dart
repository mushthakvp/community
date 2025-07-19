import '../../domain/entities/search_product.dart';

class SearchProductModel extends SearchProduct {
  const SearchProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.images,
    required super.price,
    required super.offerPrice,
    required super.commission,
  });

  factory SearchProductModel.fromJson(Map<String, dynamic> json) {
    return SearchProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      price: (json['price'] ?? 0).toDouble(),
      offerPrice: (json['offerPrice'] ?? 0).toDouble(),
      commission: (json['commission'] ?? 0).toDouble(),
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
    };
  }
}
