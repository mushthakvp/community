import 'package:equatable/equatable.dart';

import 'product_listing_item.dart';

class ProductListingData extends Equatable {
  final bool success;
  final String message;
  final List<ProductListingItem> products;
  final int totalPages;
  final int currentPage;
  final int totalItems;

  const ProductListingData({
    required this.success,
    required this.message,
    required this.products,
    required this.totalPages,
    required this.currentPage,
    required this.totalItems,
  });

  @override
  List<Object?> get props => [
    success,
    message,
    products,
    totalPages,
    currentPage,
    totalItems,
  ];
}
