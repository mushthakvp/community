import '../../domain/entities/home_data.dart';
import 'banner_model.dart';
import 'category_model.dart';
import 'product_model.dart';

class HomeDataModel extends HomeData {
  const HomeDataModel({
    required super.success,
    required super.message,
    required super.categories,
    required super.banners,
    required super.popularProducts,
    required super.topBrands,
    required super.topSellingProducts,
    super.shippingAddress,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      categories:
          (json['sections'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      banners:
          (json['banners'] as List<dynamic>?)
              ?.map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      popularProducts:
          (json['products'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      topBrands:
          (json['topBrands'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      topSellingProducts:
          (json['topSellingProducts'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      shippingAddress: json['shippingAddress']?['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'sections': categories.map((e) => (e as CategoryModel).toJson()).toList(),
      'banners': banners.map((e) => (e as BannerModel).toJson()).toList(),
      'products': popularProducts
          .map((e) => (e as ProductModel).toJson())
          .toList(),
      'topBrands': topBrands.map((e) => (e as CategoryModel).toJson()).toList(),
      'topSellingProducts': topSellingProducts
          .map((e) => (e as ProductModel).toJson())
          .toList(),
      'shippingAddress': {'address': shippingAddress},
    };
  }
}
