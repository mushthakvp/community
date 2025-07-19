import '../../domain/entities/category.dart';

class CategoryItemModel extends CategoryItem {
  const CategoryItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    super.sectionId,
    required super.isSubCategory,
    required super.isDeleted,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CategoryItemModel.fromJson(Map<String, dynamic> json) {
    return CategoryItemModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? '',
      sectionId: json['sectionId'],
      isSubCategory: json['isSubCategory'] ?? false,
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
      'sectionId': sectionId,
      'isSubCategory': isSubCategory,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CategoriesResponseModel {
  final bool success;
  final String message;
  final List<CategoryItemModel> categories;
  final int totalPage;

  const CategoriesResponseModel({
    required this.success,
    required this.message,
    required this.categories,
    required this.totalPage,
  });

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoriesResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map(
                (e) => CategoryItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      totalPage: json['totalPage'] ?? 0,
    );
  }
}
