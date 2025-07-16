import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final double price;
  final double offerPrice;
  final double commission;
  final bool isActive;
  final String categoryId;
  final String brandId;
  final Map<String, dynamic>? specifications;
  final double rating;
  final int reviewCount;
  final bool isWishlisted;
  final bool inStock;
  final int stockCount;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.price,
    required this.offerPrice,
    required this.commission,
    required this.isActive,
    required this.categoryId,
    required this.brandId,
    this.specifications,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isWishlisted = false,
    this.inStock = true,
    this.stockCount = 0,
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
    images,
    price,
    offerPrice,
    commission,
    isActive,
    categoryId,
    brandId,
    specifications,
    rating,
    reviewCount,
    isWishlisted,
    inStock,
    stockCount,
  ];
}
