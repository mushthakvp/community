import 'package:equatable/equatable.dart';

class CompanyEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String? phone;
  final String? website;
  final String? description;
  final String? image;
  final LocationEntity? location;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CompanyEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    this.phone,
    this.website,
    this.description,
    this.image,
    this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    email,
    phone,
    website,
    description,
    image,
    location,
    createdAt,
    updatedAt,
  ];
}

class LocationEntity extends Equatable {
  final String latitude;
  final String longitude;

  const LocationEntity({required this.latitude, required this.longitude});

  @override
  List<Object> get props => [latitude, longitude];
}
