import 'package:equatable/equatable.dart';

import 'category.dart';
import 'section.dart';
import 'subcategory.dart';

class CategoriesData extends Equatable {
  final bool success;
  final String message;
  final List<Section> sections;
  final List<CategoryItem> categories;
  final List<SubCategory> subCategories;
  final int totalPages;

  const CategoriesData({
    required this.success,
    required this.message,
    required this.sections,
    required this.categories,
    required this.subCategories,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [
    success,
    message,
    sections,
    categories,
    subCategories,
    totalPages,
  ];
}
