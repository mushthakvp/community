import '../../domain/entities/search_results.dart';
import 'search_product_model.dart';

class SearchResultsModel extends SearchResults {
  const SearchResultsModel({
    required super.success,
    required super.message,
    required super.products,
    required super.totalPages,
  });

  factory SearchResultsModel.fromJson(Map<String, dynamic> json) {
    return SearchResultsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      products:
          (json['products'] as List<dynamic>?)
              ?.map(
                (e) => SearchProductModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      totalPages: json['totalPages'] ?? 0,
    );
  }
}
