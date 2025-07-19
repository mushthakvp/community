import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/error/failures.dart';
import '../../domain/entities/product_filter_params.dart';
import '../../domain/entities/product_listing_item.dart';
import '../../domain/usecases/get_filtered_product_count.dart';
import '../../domain/usecases/get_products.dart';

class VCartProductListingController extends GetxController {
  final GetProducts getProductsUseCase;
  final GetFilteredProductCount getFilteredProductCountUseCase;

  VCartProductListingController({
    required this.getProductsUseCase,
    required this.getFilteredProductCountUseCase,
  });

  // Observable variables
  final _isLoading = false.obs;
  final _products = <ProductListingItem>[].obs;
  final _filterParams = ProductFilterParams().obs;
  final _productCount = 0.obs;
  final _errorMessage = ''.obs;
  final _hasError = false.obs;

  // Pagination variables
  final _hasMoreData = true.obs;
  final _currentPage = 1.obs;
  final _itemsPerPage = 10;
  final _isPageDataEmpty = false.obs;

  // Sort options
  final _selectedSortOption = 'high-to-low'.obs;
  final _tempSelectedSortOption = 'Price - High-to-low'.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<ProductListingItem> get products => _products;
  ProductFilterParams get filterParams => _filterParams.value;
  int get productCount => _productCount.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _hasError.value;
  bool get hasMoreData => _hasMoreData.value;
  bool get isPageDataEmpty => _isPageDataEmpty.value;
  String get selectedSortOption => _selectedSortOption.value;
  String get tempSelectedSortOption => _tempSelectedSortOption.value;

  void setFilterParams({
    String? sectionId,
    String? categoryId,
    String? subCategoryId,
    String? brandId,
  }) {
    _filterParams.value = filterParams.copyWith(
      sectionId: sectionId,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      brandId: brandId,
    );
  }

  Future<void> getProducts({bool isLoadMore = false}) async {
    try {
      if (!isLoadMore) {
        _currentPage.value = 1;
        _products.clear();
        _hasMoreData.value = true;
        _isPageDataEmpty.value = false;
      }

      if (!_hasMoreData.value) return;

      _setLoading(true);
      _clearError();

      final params = filterParams.copyWith(
        page: _currentPage.value,
        limit: _itemsPerPage,
      );
      final result = await getProductsUseCase(params);

      result.fold((failure) => _handleFailure(failure), (data) {
        if (data.products.isEmpty) {
          _isPageDataEmpty.value = true;
          _hasMoreData.value = false;
        } else {
          _products.addAll(data.products);
          _isPageDataEmpty.value = false;
          _hasMoreData.value = _currentPage.value < data.totalPages;
          if (_hasMoreData.value) {
            _currentPage.value++;
          }
        }
        _setLoading(false);
      });
    } catch (e) {
      _handleError('Unexpected error occurred: $e');
    }
  }

  Future<void> getFilteredProductCount() async {
    try {
      final result = await getFilteredProductCountUseCase(filterParams);
      result.fold(
        (failure) {
          // Handle count failure silently
        },
        (count) {
          _productCount.value = count;
        },
      );
    } catch (e) {
      // Handle count error silently
    }
  }

  void setSelectedSortOption(String title, BuildContext context) {
    _tempSelectedSortOption.value = title;

    if (title.contains("Price - Low to High")) {
      _selectedSortOption.value = 'low-to-high';
    } else if (title.contains("Price - High to Low")) {
      _selectedSortOption.value = 'high-to-low';
    } else {
      _selectedSortOption.value = title.toLowerCase();
    }

    _filterParams.value = filterParams.copyWith(
      sortBy: _selectedSortOption.value,
    );
    refreshProducts();
  }

  void applyFilters({
    double? minPrice,
    double? maxPrice,
    List<String>? colors,
    List<String>? sizes,
    List<String>? offers,
  }) {
    _filterParams.value = filterParams.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
      colors: colors,
      sizes: sizes,
      offers: offers,
    );
    refreshProducts();
  }

  void clearFilters() {
    _filterParams.value = ProductFilterParams(
      sectionId: filterParams.sectionId,
      categoryId: filterParams.categoryId,
      subCategoryId: filterParams.subCategoryId,
      brandId: filterParams.brandId,
      sortBy: _selectedSortOption.value,
    );
    refreshProducts();
  }

  Future<void> refreshProducts() async {
    _currentPage.value = 1;
    _hasMoreData.value = true;
    _products.clear();
    await getProducts();
  }

  void clearAllVariables() {
    _products.clear();
    _filterParams.value = ProductFilterParams();
    _isLoading.value = false;
    _hasMoreData.value = true;
    _currentPage.value = 1;
    _isPageDataEmpty.value = false;
    _selectedSortOption.value = 'high-to-low';
    _tempSelectedSortOption.value = 'Price - High-to-low';
    _productCount.value = 0;
    _clearError();
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
    _products.close();
    _filterParams.close();
    _productCount.close();
    _errorMessage.close();
    _hasError.close();
    _isLoading.close();
    _hasMoreData.close();
    _currentPage.close();
    _isPageDataEmpty.close();
    _selectedSortOption.close();
    _tempSelectedSortOption.close();
    super.onClose();
  }
}
