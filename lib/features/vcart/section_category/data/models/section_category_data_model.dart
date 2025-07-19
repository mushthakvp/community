import '../../domain/entities/section_category_data.dart';
import 'section_category_item_model.dart';

class SectionCategoryDataModel extends SectionCategoryData {
  const SectionCategoryDataModel({
    required super.success,
    required super.message,
    required super.categories,
    required super.totalPages,
  });

  factory SectionCategoryDataModel.fromJson(Map<String, dynamic> json) {
    return SectionCategoryDataModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map(
                (e) => SectionCategoryItemModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'categories': categories
          .map((e) => (e as SectionCategoryItemModel).toJson())
          .toList(),
      'totalPages': totalPages,
    };
  }
}
