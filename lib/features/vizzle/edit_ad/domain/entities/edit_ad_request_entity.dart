import 'package:equatable/equatable.dart';

class EditAdRequestEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String phone;
  final double? price;
  final String district;
  final String latitude;
  final String longitude;
  final String address;
  final List<String> images;
  final List<String> newImages;
  final List<String> removedImages;

  const EditAdRequestEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.phone,
    this.price,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.images,
    required this.newImages,
    required this.removedImages,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    phone,
    price,
    district,
    latitude,
    longitude,
    address,
    images,
    newImages,
    removedImages,
  ];
}
