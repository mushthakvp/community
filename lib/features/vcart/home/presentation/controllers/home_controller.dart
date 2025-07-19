import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_home_data.dart';
import '../../domain/usecases/get_location.dart';

class VCartHomeController extends GetxController {
  final GetHomeData getHomeDataUseCase;
  final GetLocation getLocationUseCase;

  VCartHomeController({
    required this.getHomeDataUseCase,
    required this.getLocationUseCase,
  });

  // Observable variables
  final _isLoading = false.obs;
  final _isLocationLoading = false.obs;
  final _homeData = Rxn<HomeData>();
  final _location = ''.obs;
  final _errorMessage = ''.obs;
  final _hasError = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isLocationLoading => _isLocationLoading.value;
  HomeData? get homeData => _homeData.value;
  String get location => _location.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _hasError.value;

  // Computed properties
  List<dynamic> get categories => homeData?.categories ?? [];
  List<dynamic> get banners => homeData?.banners ?? [];
  List<dynamic> get popularProducts => homeData?.popularProducts ?? [];
  List<dynamic> get topBrands => homeData?.topBrands ?? [];
  List<dynamic> get topSellingProducts => homeData?.topSellingProducts ?? [];
  String? get shippingAddress => homeData?.shippingAddress;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([fetchHomeData(), getCurrentLocation()]);
  }

  Future<void> fetchHomeData({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh && homeData != null) return;

      _setLoading(true);
      _clearError();

      final result = await getHomeDataUseCase(NoParams());

      result.fold((failure) => _handleFailure(failure), (data) {
        _homeData.value = data;
        _setLoading(false);
      });
    } catch (e) {
      _handleError('Unexpected error occurred: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      _isLocationLoading.value = true;

      final result = await getLocationUseCase(NoParams());

      result.fold(
        (failure) {
          _isLocationLoading.value = false;
        },
        (locationData) {
          _location.value = locationData;
          _isLocationLoading.value = false;
        },
      );
    } catch (e) {
      _isLocationLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchHomeData(forceRefresh: true);
  }

  // Method to update wishlist status for products
  void updateProductWishlistStatus(String productId, bool isWishlisted) {
    if (homeData == null) return;

    // Update popular products
    final updatedPopularProducts = popularProducts.map((product) {
      if (product is Product && product.id == productId) {
        return Product(
          id: product.id,
          name: product.name,
          description: product.description,
          images: product.images,
          price: product.price,
          offerPrice: product.offerPrice,
          commission: product.commission,
          isActive: product.isActive,
          categoryId: product.categoryId,
          brandId: product.brandId,
          specifications: product.specifications,
          rating: product.rating,
          reviewCount: product.reviewCount,
          isWishlisted: isWishlisted, // Update the wishlist status
          inStock: product.inStock,
          stockCount: product.stockCount,
        );
      }
      return product;
    }).toList();

    // Update top selling products
    final updatedTopSellingProducts = topSellingProducts.map((product) {
      if (product is Product && product.id == productId) {
        return Product(
          id: product.id,
          name: product.name,
          description: product.description,
          images: product.images,
          price: product.price,
          offerPrice: product.offerPrice,
          commission: product.commission,
          isActive: product.isActive,
          categoryId: product.categoryId,
          brandId: product.brandId,
          specifications: product.specifications,
          rating: product.rating,
          reviewCount: product.reviewCount,
          isWishlisted: isWishlisted, // Update the wishlist status
          inStock: product.inStock,
          stockCount: product.stockCount,
        );
      }
      return product;
    }).toList();

    // Create updated home data
    final updatedHomeData = HomeData(
      success: homeData!.success,
      message: homeData!.message,
      categories: homeData!.categories,
      banners: homeData!.banners,
      popularProducts: updatedPopularProducts.cast<Product>(),
      topBrands: homeData!.topBrands,
      topSellingProducts: updatedTopSellingProducts.cast<Product>(),
      shippingAddress: homeData!.shippingAddress,
    );

    _homeData.value = updatedHomeData;
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }

  void _handleFailure(Failure failure) {
    _setLoading(false);
    _handleError(failure.message);
  }

  void _handleError(String message) {
    _hasError.value = true;
    _errorMessage.value = message;
    _setLoading(false);
  }

  @override
  void onClose() {
    _homeData.close();
    _location.close();
    _errorMessage.close();
    _hasError.close();
    _isLoading.close();
    _isLocationLoading.close();
    super.onClose();
  }

  void showVCartSnackBar(String s) {
    Get.snackbar(
      'V-Cart',
      s,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
