import 'package:equatable/equatable.dart';

import 'brand.dart';
import 'product_size.dart';
import 'specification.dart';
import 'variant.dart';

class ProductDetail extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final double price;
  final double offerPrice;
  final double commission;
  final double offerPercentage;
  final List<Specification> specifications;
  final String returnPolicy;
  final Brand brand;
  final bool isReturn;
  final int returnDuration;
  final List<ProductSize> sizes;
  final List<Variant> variants;
  final double rating;
  final int reviewCount;

  const ProductDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.price,
    required this.offerPrice,
    required this.commission,
    required this.offerPercentage,
    required this.specifications,
    required this.returnPolicy,
    required this.brand,
    required this.isReturn,
    required this.returnDuration,
    required this.sizes,
    required this.variants,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  double get finalPrice => price + commission;
  double get finalOfferPrice => offerPrice + commission;
  bool get hasDiscount => offerPrice < price;
  String get primaryImage => images.isNotEmpty ? images.first : '';
  bool get hasVariants => variants.isNotEmpty;
  bool get hasSizes => sizes.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    images,
    price,
    offerPrice,
    commission,
    offerPercentage,
    specifications,
    returnPolicy,
    brand,
    isReturn,
    returnDuration,
    sizes,
    variants,
    rating,
    reviewCount,
  ];
}
