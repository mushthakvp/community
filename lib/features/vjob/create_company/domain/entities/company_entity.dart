import 'package:equatable/equatable.dart';

class CompanyEntity extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String? website;
  final String description;
  final String? image;
  final double? lat;
  final double? lng;
  final String? location;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? action;

  const CompanyEntity({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.website,
    required this.description,
    this.image,
    this.lat,
    this.lng,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.action,
  });

  CompanyEntity copyWith({
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
    return CompanyEntity(
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
      action: action ?? action,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    website,
    description,
    image,
    lat,
    lng,
    location,
    createdAt,
    updatedAt,
    action,
  ];
}

class ImageUploadEntity extends Equatable {
  final String fileKey;
  final String? url;
  final double progress;
  final bool isCompleted;
  final String? error;

  const ImageUploadEntity({
    required this.fileKey,
    this.url,
    this.progress = 0.0,
    this.isCompleted = false,
    this.error,
  });

  ImageUploadEntity copyWith({
    String? fileKey,
    String? url,
    double? progress,
    bool? isCompleted,
    String? error,
  }) {
    return ImageUploadEntity(
      fileKey: fileKey ?? this.fileKey,
      url: url ?? this.url,
      progress: progress ?? this.progress,
      isCompleted: isCompleted ?? this.isCompleted,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [fileKey, url, progress, isCompleted, error];
}
