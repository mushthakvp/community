import '../../domain/entities/variant.dart';

class VariantModel extends Variant {
  const VariantModel({required super.variantId, required super.images});

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      variantId: json['variantId'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {'variantId': variantId, 'images': images};
  }
}
