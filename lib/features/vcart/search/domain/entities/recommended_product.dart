import 'package:equatable/equatable.dart';

class RecommendedProduct extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final double price;
  final double offerPrice;
  final double commission;

  const RecommendedProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.price,
    required this.offerPrice,
    required this.commission,
  });

  double get finalPrice => price + commission;
  double get finalOfferPrice => offerPrice + commission;
  bool get hasDiscount => offerPrice < price;
  String get primaryImage => images.isNotEmpty ? images.first : '';

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    images,
    price,
    offerPrice,
    commission,
  ];
}
