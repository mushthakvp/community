import '../../domain/entities/company_entity.dart';

class CompanyModel extends CompanyEntity {
  const CompanyModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.email,
    super.phone,
    super.website,
    super.description,
    super.image,
    super.location,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['_id'] ?? '',
      userId: json['user'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      website: json['website'],
      description: json['description'],
      image: json['image'],
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'website': website,
      'description': description,
      'image': image,
      'location': location != null
          ? (location as LocationModel).toJson()
          : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class LocationModel extends LocationEntity {
  const LocationModel({required super.latitude, required super.longitude});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['lat'] ?? '0',
      longitude: json['lng'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': latitude, 'lng': longitude};
  }
}

class CompanyResponseModel {
  final bool success;
  final String message;
  final List<CompanyModel> companies;
  final int total;
  final int totalPage;

  CompanyResponseModel({
    required this.success,
    required this.message,
    required this.companies,
    required this.total,
    required this.totalPage,
  });

  factory CompanyResponseModel.fromJson(Map<String, dynamic> json) {
    return CompanyResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      companies:
          (json['companies'] as List?)
              ?.map((company) => CompanyModel.fromJson(company))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
    );
  }
}
