import 'package:equatable/equatable.dart';

import 'recent_search.dart';
import 'recommended_product.dart';
import 'search_section.dart';

class SearchData extends Equatable {
  final bool success;
  final String message;
  final List<RecentSearch> recentSearches;
  final List<SearchSection> sections;
  final List<RecommendedProduct> recommended;

  const SearchData({
    required this.success,
    required this.message,
    required this.recentSearches,
    required this.sections,
    required this.recommended,
  });

  @override
  List<Object?> get props => [
    success,
    message,
    recentSearches,
    sections,
    recommended,
  ];
}
