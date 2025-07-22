import 'package:equatable/equatable.dart';

class OrderReview extends Equatable {
  final String orderId;
  final double rating;
  final String review;
  final List<String> images;

  const OrderReview({
    required this.orderId,
    required this.rating,
    required this.review,
    required this.images,
  });

  @override
  List<Object?> get props => [orderId, rating, review, images];
}
