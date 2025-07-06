import '../../domain/entities/company_selection_entity.dart';

class CompanySelectionModel extends CompanySelectionEntity {
  const CompanySelectionModel({
    required super.id,
    required super.name,
    required super.image,
    super.email,
    super.website,
  });

  factory CompanySelectionModel.fromJson(Map<String, dynamic> json) {
    return CompanySelectionModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      email: json['email'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'email': email,
      'website': website,
    };
  }
}
