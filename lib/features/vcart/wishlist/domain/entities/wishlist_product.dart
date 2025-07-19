import 'package:equatable/equatable.dart';

class WishlistProduct extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double offerPrice;
  final double commission;
  final List<String> images;

  const WishlistProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.offerPrice,
    required this.commission,
    required this.images,
  });

  double get finalPrice => price + commission;
  double get finalOfferPrice => offerPrice + commission;
  bool get hasDiscount => offerPrice < price;
  double get discountPercentage =>
      hasDiscount ? ((price - offerPrice) / price) * 100 : 0;
  String get primaryImage => images.isNotEmpty ? images.first : '';

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    offerPrice,
    commission,
    images,
  ];
}
