import '../../domain/entities/filter_brand.dart';

class FilterBrandModel extends FilterBrand {
  const FilterBrandModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.description,
    required super.isDeleted,
    required super.createdAt,
    required super.updatedAt,
  });

  factory FilterBrandModel.fromJson(Map<String, dynamic> json) {
    return FilterBrandModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['image'] ?? '',
      description: json['description'] ?? '',
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
      'image': imageUrl,
      'description': description,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
