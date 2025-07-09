import '../../domain/entities/company_entity.dart';

class CompanyModel extends CompanyEntity {
  const CompanyModel({
    super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.website,
    required super.description,
    super.image,
    super.lat,
    super.lng,
    super.location,
    super.createdAt,
    super.updatedAt,
    super.action,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['_id'] ?? json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'],
      description: json['description'] ?? '',
      image: json['image'],
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
      location: json['location'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      action: json['action'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'action'
              'name':
          name,
      'email': email,
      'phone': phone,
      if (website != null) 'website': website,
      'description': description,
      if (image != null) 'image': image,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (location != null) 'location': location,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      'action': action,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'action': 'create',
      'name': name,
      'email': email,
      'phone': phone,
      if (website != null && website!.isNotEmpty) 'website': website,
      'description': description,
      if (image != null && image!.isNotEmpty) 'image': image,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'action': 'update',
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      if (website != null && website!.isNotEmpty) 'website': website,
      'description': description,
      if (image != null && image!.isNotEmpty) 'image': image,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    };
  }

  factory CompanyModel.fromEntity(CompanyEntity entity) {
    return CompanyModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      website: entity.website,
      description: entity.description,
      image: entity.image,
      lat: entity.lat,
      lng: entity.lng,
      location: entity.location,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  CompanyModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? website,
    String? description,
    String? image,
    double? lat,
    double? lng,
    String? location,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      description: description ?? this.description,
      image: image ?? this.image,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CreateCompanyResponse {
  final bool success;
  final String message;
  final CompanyModel? company;

  CreateCompanyResponse({
    required this.success,
    required this.message,
    this.company,
  });

  factory CreateCompanyResponse.fromJson(Map<String, dynamic> json) {
    return CreateCompanyResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      company: json['company'] != null
          ? CompanyModel.fromJson(json['company'])
          : null,
    );
  }
}
