import '../../domain/entities/product_listing_data.dart';
import 'product_listing_item_model.dart';

class ProductListingDataModel extends ProductListingData {
  const ProductListingDataModel({
    required super.success,
    required super.message,
    required super.products,
    required super.totalPages,
    required super.currentPage,
    required super.totalItems,
  });

  factory ProductListingDataModel.fromJson(Map<String, dynamic> json) {
    return ProductListingDataModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      products:
          (json['products'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ProductListingItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      totalItems: json['totalItems'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'products': products
          .map((e) => (e as ProductListingItemModel).toJson())
          .toList(),
      'totalPages': totalPages,
      'currentPage': currentPage,
      'totalItems': totalItems,
    };
  }
}
