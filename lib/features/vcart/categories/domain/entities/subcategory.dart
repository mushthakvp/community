import 'package:equatable/equatable.dart';

class SubCategory extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String? categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    categoryId,
    createdAt,
    updatedAt,
  ];
}
