import 'package:equatable/equatable.dart';

import 'banner.dart';
import 'category.dart';
import 'product.dart';

class HomeData extends Equatable {
  final bool success;
  final String message;
  final List<Category> categories;
  final List<Banner> banners;
  final List<Product> popularProducts;
  final List<Category> topBrands;
  final List<Product> topSellingProducts;
  final String? shippingAddress;

  const HomeData({
    required this.success,
    required this.message,
    required this.categories,
    required this.banners,
    required this.popularProducts,
    required this.topBrands,
    required this.topSellingProducts,
    this.shippingAddress,
  });

  @override
  List<Object?> get props => [
    success,
    message,
    categories,
    banners,
    popularProducts,
    topBrands,
    topSellingProducts,
    shippingAddress,
  ];
}
