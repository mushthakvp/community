import '../../domain/entities/section.dart';

class SectionModel extends Section {
  const SectionModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.isDeleted,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'image': imageUrl,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class SectionsResponseModel {
  final bool success;
  final String message;
  final List<SectionModel> sections;
  final int totalPages;

  const SectionsResponseModel({
    required this.success,
    required this.message,
    required this.sections,
    required this.totalPages,
  });

  factory SectionsResponseModel.fromJson(Map<String, dynamic> json) {
    return SectionsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      sections:
          (json['sections'] as List<dynamic>?)
              ?.map((e) => SectionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalPages: json['totalPages'] ?? 0,
    );
  }
}
