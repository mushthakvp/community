import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String? imageUrl;
  final List<SubCategory> subcategories;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.subcategories,
    this.isDeleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    subcategories,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}

class SubCategory extends Equatable {
  final String id;
  final String name;
  final String categoryId;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubCategory({
    required this.id,
    required this.name,
    required this.categoryId,
    this.isDeleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    categoryId,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}
