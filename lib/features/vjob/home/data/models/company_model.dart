import '../../domain/entities/company_entity.dart';
import 'location_model.dart';

class CompanyModel extends CompanyEntity {
  const CompanyModel({
    required super.id,
    required super.name,
    required super.image,
    super.email,
    super.phone,
    super.website,
    super.description,
    super.location,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    try {
      return CompanyModel(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        image: json['image'] ?? '',
        email: json['email'],
        phone: json['phone'],
        website: json['website'],
        description: json['description'],
        location: json['location'] != null
            ? LocationModel.fromJson(json['location'])
            : null,
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      );
    } catch (e) {
      throw FormatException('Error parsing CompanyModel: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'email': email,
      'phone': phone,
      'website': website,
      'description': description,
      'location': location != null
          ? (location as LocationModel).toJson()
          : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
