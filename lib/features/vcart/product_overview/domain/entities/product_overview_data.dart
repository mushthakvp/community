import 'package:equatable/equatable.dart';

import 'product_detail.dart';
import 'review.dart';

class ProductOverviewData extends Equatable {
  final bool success;
  final String message;
  final ProductDetail productDetail;
  final bool isAddedWishList;
  final List<Review> reviews;
  final double averageRating;
  final int totalReviews;

  const ProductOverviewData({
    required this.success,
    required this.message,
    required this.productDetail,
    required this.isAddedWishList,
    required this.reviews,
    this.averageRating = 0.0,
    this.totalReviews = 0,
  });

  @override
  List<Object?> get props => [
    success,
    message,
    productDetail,
    isAddedWishList,
    reviews,
    averageRating,
    totalReviews,
  ];
}
