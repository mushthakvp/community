import '../../domain/entities/product_detail.dart';
import 'brand_model.dart';
import 'product_size_model.dart';
import 'specification_model.dart';
import 'variant_model.dart';

class ProductDetailModel extends ProductDetail {
  const ProductDetailModel({
    required super.id,
    required super.name,
    required super.description,
    required super.images,
    required super.price,
    required super.offerPrice,
    required super.commission,
    required super.offerPercentage,
    required super.specifications,
    required super.returnPolicy,
    required super.brand,
    required super.isReturn,
    required super.returnDuration,
    required super.sizes,
    required super.variants,
    super.rating,
    super.reviewCount,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      price: (json['price'] ?? 0).toDouble(),
      offerPrice: (json['offerPrice'] ?? 0).toDouble(),
      commission: (json['commission'] ?? 0).toDouble(),
      offerPercentage: (json['offerPercentage'] ?? 0).toDouble(),
      specifications:
          (json['specification'] as List<dynamic>?)
              ?.map(
                (e) => SpecificationModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      returnPolicy: json['returnPolicy'] ?? '',
      brand: BrandModel.fromJson(json['brand'] ?? {}),
      isReturn: json['isReturn'] ?? false,
      returnDuration: json['returnDuration'] ?? 0,
      sizes:
          (json['sizes'] as List<dynamic>?)
              ?.map((e) => ProductSizeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      variants:
          (json['variants'] as List<dynamic>?)
              ?.map((e) => VariantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
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
      'offerPercentage': offerPercentage,
      'specification': specifications
          .map((e) => (e as SpecificationModel).toJson())
          .toList(),
      'returnPolicy': returnPolicy,
      'brand': (brand as BrandModel).toJson(),
      'isReturn': isReturn,
      'returnDuration': returnDuration,
      'sizes': sizes.map((e) => (e as ProductSizeModel).toJson()).toList(),
      'variants': variants.map((e) => (e as VariantModel).toJson()).toList(),
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}
