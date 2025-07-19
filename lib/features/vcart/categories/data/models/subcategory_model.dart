import '../../domain/entities/subcategory.dart';

class SubCategoryModel extends SubCategory {
  const SubCategoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    super.categoryId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? '',
      categoryId: json['categoryId'],
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
      'categoryId': categoryId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class SubCategoriesResponseModel {
  final bool success;
  final String message;
  final List<SubCategoryModel> subCategories;
  final int totalPage;

  const SubCategoriesResponseModel({
    required this.success,
    required this.message,
    required this.subCategories,
    required this.totalPage,
  });

  factory SubCategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    return SubCategoriesResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      subCategories:
          (json['subCategories'] as List<dynamic>?)
              ?.map((e) => SubCategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalPage: json['totalPage'] ?? 0,
    );
  }
}
