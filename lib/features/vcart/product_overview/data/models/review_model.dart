import '../../domain/entities/review.dart';
import 'user_model.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.user,
    required super.reviewText,
    required super.rating,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'] ?? '',
      user: UserModel.fromJson(json['userId'] ?? {}),
      reviewText: json['review'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': (user as UserModel).toJson(),
      'review': reviewText,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
