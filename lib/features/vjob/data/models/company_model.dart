import '../../domain/entities/company_entity.dart';
import 'location_model.dart';

class CompanyModel extends CompanyEntity {
  const CompanyModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.image,
    super.website,
    super.description,
    super.location,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      image: json['image'],
      website: json['website'],
      description: json['description'],
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'website': website,
      'description': description,
      'location': (location as LocationModel?)?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
