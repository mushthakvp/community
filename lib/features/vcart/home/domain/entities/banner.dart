import 'package:equatable/equatable.dart';

class Banner extends Equatable {
  final String id;
  final String field;
  final String? sectionId;
  final String? categoryId;
  final String? subCategoryId;
  final String? productId;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Banner({
    required this.id,
    required this.field,
    this.sectionId,
    this.categoryId,
    this.subCategoryId,
    this.productId,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  @override
  List<Object?> get props => [
    id,
    field,
    sectionId,
    categoryId,
    subCategoryId,
    productId,
    imageUrl,
    startDate,
    endDate,
    createdAt,
    updatedAt,
  ];
}
