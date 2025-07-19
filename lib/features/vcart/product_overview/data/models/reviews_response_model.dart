import 'review_model.dart';

class ReviewsResponseModel {
  final bool success;
  final String message;
  final List<ReviewModel> reviews;
  final double totalRating;
  final int total;
  final int totalPages;

  const ReviewsResponseModel({
    required this.success,
    required this.message,
    required this.reviews,
    required this.totalRating,
    required this.total,
    required this.totalPages,
  });

  factory ReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    return ReviewsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalRating: (json['totalRating'] ?? 0).toDouble(),
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}
