import 'package:equatable/equatable.dart';

import 'location_entity.dart';

class CompanyEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final String? email;
  final String? phone;
  final String? website;
  final String? description;
  final LocationEntity? location;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CompanyEntity({
    required this.id,
    required this.name,
    required this.image,
    this.email,
    this.phone,
    this.website,
    this.description,
    this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  CompanyEntity copyWith({
    String? id,
    String? name,
    String? image,
    String? email,
    String? phone,
    String? website,
    String? description,
    LocationEntity? location,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompanyEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      description: description ?? this.description,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    image,
    email,
    phone,
    website,
    description,
    location,
    createdAt,
    updatedAt,
  ];
}
