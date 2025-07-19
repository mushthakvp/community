import '../../domain/entities/product_overview_data.dart';
import 'product_detail_model.dart';

class ProductOverviewResponseModel extends ProductOverviewData {
  const ProductOverviewResponseModel({
    required super.success,
    required super.message,
    required super.productDetail,
    required super.isAddedWishList,
    required super.reviews,
    super.averageRating,
    super.totalReviews,
  });

  factory ProductOverviewResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductOverviewResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      productDetail: ProductDetailModel.fromJson(json['data'] ?? {}),
      isAddedWishList: json['isAddedWishList'] ?? false,
      reviews: [], // Reviews will be loaded separately
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
    );
  }
}
