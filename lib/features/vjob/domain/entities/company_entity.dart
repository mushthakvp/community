import 'package:equatable/equatable.dart';
import 'package:livera/features/vjob/domain/entities/job_entity.dart';

class CompanyEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? image;
  final String? website;
  final String? description;
  final LocationEntity? location;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CompanyEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.image,
    this.website,
    this.description,
    this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  CompanyEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? image,
    String? website,
    String? description,
    LocationEntity? location,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompanyEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      website: website ?? this.website,
      description: description ?? this.description,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get displayName => name.isNotEmpty ? name : 'Unknown Company';
  String get safeImageUrl => image ?? '';
  bool get isValid => id.isNotEmpty && name.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    image,
    website,
    description,
    location,
    createdAt,
    updatedAt,
  ];
}
