import 'package:equatable/equatable.dart';

import 'section_category_item.dart';

class SectionCategoryData extends Equatable {
  final bool success;
  final String message;
  final List<SectionCategoryItem> categories;
  final int totalPages;

  const SectionCategoryData({
    required this.success,
    required this.message,
    required this.categories,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [success, message, categories, totalPages];
}
