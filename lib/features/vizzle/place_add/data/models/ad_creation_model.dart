import '../../domain/entities/ad_creation.dart';

class AdCreationRequestModel extends AdCreationRequest {
  const AdCreationRequestModel({
    required super.title,
    required super.description,
    super.price,
    required super.phoneNumber,
    required super.district,
    required super.categoryId,
    required super.subCategoryId,
    super.subSubCategoryId,
    required super.images,
    required super.latitude,
    required super.longitude,
    required super.address,
    super.additionalFields,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'title': title,
      'description': description,
      'phone': phoneNumber,
      'district': district,
      'category': categoryId,
      'subCategory': subCategoryId,
      'images': images,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'address': address,
    };

    if (price != null) {
      json['price'] = price;
    }

    if (subSubCategoryId != null) {
      json['subSubcategory'] = subSubCategoryId;
    }

    // Add all additional fields
    json.addAll(additionalFields);

    return json;
  }
}

class AdCreationResponseModel extends AdCreationResponse {
  const AdCreationResponseModel({
    required super.id,
    required super.message,
    required super.success,
  });

  factory AdCreationResponseModel.fromJson(Map<String, dynamic> json) {
    return AdCreationResponseModel(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}
