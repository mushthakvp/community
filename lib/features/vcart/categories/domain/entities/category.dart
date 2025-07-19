import 'package:equatable/equatable.dart';

class CategoryItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String? sectionId;
  final bool isSubCategory;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.sectionId,
    required this.isSubCategory,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    sectionId,
    isSubCategory,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}
