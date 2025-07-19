import '../../domain/entities/search_section.dart';

class SearchSectionModel extends SearchSection {
  const SearchSectionModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.isDeleted,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SearchSectionModel.fromJson(Map<String, dynamic> json) {
    return SearchSectionModel(
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
