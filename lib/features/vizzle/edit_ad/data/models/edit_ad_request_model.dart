import '../../domain/entities/edit_ad_request_entity.dart';

class EditAdRequestModel extends EditAdRequestEntity {
  const EditAdRequestModel({
    required super.id,
    required super.title,
    required super.description,
    required super.phone,
    super.price,
    required super.district,
    required super.latitude,
    required super.longitude,
    required super.address,
    required super.images,
    required super.newImages,
    required super.removedImages,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'phone': phone,
      'price': price,
      'district': district,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'images': images,
      'newImages': newImages,
      'removedImages': removedImages,
    };
  }

  factory EditAdRequestModel.fromEntity(EditAdRequestEntity entity) {
    return EditAdRequestModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      phone: entity.phone,
      price: entity.price,
      district: entity.district,
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
      images: entity.images,
      newImages: entity.newImages,
      removedImages: entity.removedImages,
    );
  }
}
