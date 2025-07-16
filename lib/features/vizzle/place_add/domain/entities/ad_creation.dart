import 'package:equatable/equatable.dart';

class AdCreationRequest extends Equatable {
  final String title;
  final String description;
  final double? price;
  final String phoneNumber;
  final String district;
  final String categoryId;
  final String subCategoryId;
  final String? subSubCategoryId;
  final List<String> images;
  final double latitude;
  final double longitude;
  final String address;
  final Map<String, dynamic> additionalFields;

  const AdCreationRequest({
    required this.title,
    required this.description,
    this.price,
    required this.phoneNumber,
    required this.district,
    required this.categoryId,
    required this.subCategoryId,
    this.subSubCategoryId,
    required this.images,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.additionalFields = const {},
  });

  @override
  List<Object?> get props => [
    title,
    description,
    price,
    phoneNumber,
    district,
    categoryId,
    subCategoryId,
    subSubCategoryId,
    images,
    latitude,
    longitude,
    address,
    additionalFields,
  ];
}

class AdCreationResponse extends Equatable {
  final String id;
  final String message;
  final bool success;

  const AdCreationResponse({
    required this.id,
    required this.message,
    required this.success,
  });

  @override
  List<Object?> get props => [id, message, success];
}
