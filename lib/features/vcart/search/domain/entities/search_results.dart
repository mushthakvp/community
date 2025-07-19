import 'package:equatable/equatable.dart';

import 'search_product.dart';

class SearchResults extends Equatable {
  final bool success;
  final String message;
  final List<SearchProduct> products;
  final int totalPages;

  const SearchResults({
    required this.success,
    required this.message,
    required this.products,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [success, message, products, totalPages];
}
