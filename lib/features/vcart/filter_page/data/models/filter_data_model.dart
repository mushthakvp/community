import '../../domain/entities/filter_data.dart';
import 'filter_brand_model.dart';
import 'filter_color_model.dart';

class FilterDataModel extends FilterData {
  const FilterDataModel({
    required super.success,
    required super.message,
    required super.brands,
    required super.sizes,
    required super.colors,
  });

  factory FilterDataModel.fromJson(Map<String, dynamic> json) {
    return FilterDataModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      brands:
          (json['brands'] as List<dynamic>?)
              ?.map((e) => FilterBrandModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sizes: List<String>.from(json['sizes'] ?? []),
      colors:
          (json['colors'] as List<dynamic>?)
              ?.map((e) => FilterColorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'brands': brands.map((e) => (e as FilterBrandModel).toJson()).toList(),
      'sizes': sizes,
      'colors': colors.map((e) => (e as FilterColorModel).toJson()).toList(),
    };
  }
}
