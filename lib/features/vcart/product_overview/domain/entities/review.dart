import 'package:equatable/equatable.dart';

import 'user.dart';

class Review extends Equatable {
  final String id;
  final User user;
  final String reviewText;
  final double rating;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.user,
    required this.reviewText,
    required this.rating,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, user, reviewText, rating, createdAt];
}
