import 'package:equatable/equatable.dart';

class FilterBrand extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FilterBrand({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    description,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}
