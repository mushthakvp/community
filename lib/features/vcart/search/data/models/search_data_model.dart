import '../../domain/entities/search_data.dart';
import 'recent_search_model.dart';
import 'recommended_product_model.dart';
import 'search_section_model.dart';

class SearchDataModel extends SearchData {
  const SearchDataModel({
    required super.success,
    required super.message,
    required super.recentSearches,
    required super.sections,
    required super.recommended,
  });

  factory SearchDataModel.fromJson(Map<String, dynamic> json) {
    return SearchDataModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      recentSearches:
          (json['recentSearch'] as List<dynamic>?)
              ?.map(
                (e) => RecentSearchModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      sections:
          (json['sections'] as List<dynamic>?)
              ?.map(
                (e) => SearchSectionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      recommended:
          (json['recommended'] as List<dynamic>?)
              ?.map(
                (e) =>
                    RecommendedProductModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'recentSearch': recentSearches
          .map((e) => (e as RecentSearchModel).toJson())
          .toList(),
      'sections': sections
          .map((e) => (e as SearchSectionModel).toJson())
          .toList(),
      'recommended': recommended
          .map((e) => (e as RecommendedProductModel).toJson())
          .toList(),
    };
  }
}
