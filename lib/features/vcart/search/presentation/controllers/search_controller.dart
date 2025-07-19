import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/recent_search.dart';
import '../../domain/entities/recommended_product.dart';
import '../../domain/entities/search_data.dart';
import '../../domain/entities/search_product.dart';
import '../../domain/entities/search_section.dart';
import '../../domain/usecases/get_search_data.dart';
import '../../domain/usecases/search_products.dart';

class VCartSearchController extends GetxController {
  final GetSearchData getSearchDataUseCase;
  final SearchProducts searchProductsUseCase;

  VCartSearchController({
    required this.getSearchDataUseCase,
    required this.searchProductsUseCase,
  });

  // Search input controller
  final TextEditingController searchController = TextEditingController();

  // Observable variables
  final _isLoading = false.obs;
  final _isSearchLoading = false.obs;
  final _isSearched = false.obs;
  final _searchData = Rxn<SearchData>();
  final _searchProducts = <SearchProduct>[].obs;
  final _errorMessage = ''.obs;
  final _hasError = false.obs;

  // Pagination variables
  final _hasMoreData = true.obs;
  final _currentPage = 1.obs;
  final _itemsPerPage = 10;
  final _isSearchPageDataEmpty = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isSearchLoading => _isSearchLoading.value;
  bool get isSearched => _isSearched.value;
  SearchData? get searchData => _searchData.value;
  List<SearchProduct> get searchProducts => _searchProducts;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _hasError.value;
  bool get hasMoreData => _hasMoreData.value;
  bool get isSearchPageDataEmpty => _isSearchPageDataEmpty.value;

  // Computed properties
  List<RecentSearch> get recentSearches => searchData?.recentSearches ?? [];
  List<SearchSection> get sections => searchData?.sections ?? [];
  List<RecommendedProduct> get recommended => searchData?.recommended ?? [];

  @override
  void onInit() {
    super.onInit();
    fetchSearchData();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchSearchData({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh && searchData != null) return;

      _setLoading(true);
      _clearError();

      final result = await getSearchDataUseCase(NoParams());

      result.fold((failure) => _handleFailure(failure), (data) {
        _searchData.value = data;
        _setLoading(false);
      });
    } catch (e) {
      _handleError('Unexpected error occurred: $e');
    }
  }

  void checkIsClear() {
    if (searchController.text.trim().isEmpty) {
      _isSearched.value = false;
      clearSearchResults();
    }
  }

  void performSearch({String? value}) {
    if (value != null) {
      searchController.text = value;
    }

    final query = searchController.text.trim();

    if (query.length < 2) {
      _isSearched.value = false;
      clearSearchResults();
      return;
    }

    if (query.isNotEmpty) {
      _isSearched.value = true;
      clearSearchResults();
      _searchForProducts(query);
    } else {
      _isSearched.value = false;
      clearSearchResults();
    }
  }

  Future<void> _searchForProducts(
    String query, {
    bool isLoadMore = false,
  }) async {
    try {
      if (!isLoadMore) {
        _currentPage.value = 1;
        _searchProducts.clear();
        _hasMoreData.value = true;
        _isSearchPageDataEmpty.value = false;
      }

      if (!_hasMoreData.value) return;

      _setSearchLoading(true);
      _clearError();

      final result = await searchProductsUseCase(
        SearchProductsParams(
          query: query,
          page: _currentPage.value,
          limit: _itemsPerPage,
          isLoadMore: isLoadMore,
        ),
      );

      result.fold((failure) => _handleSearchFailure(failure), (results) {
        if (results.products.isEmpty) {
          _isSearchPageDataEmpty.value = true;
          _hasMoreData.value = false;
        } else {
          _searchProducts.addAll(results.products);
          _isSearchPageDataEmpty.value = false;

          final totalPages = results.totalPages;
          _hasMoreData.value = _currentPage.value < totalPages;
          if (_hasMoreData.value) {
            _currentPage.value++;
          }
        }

        _setSearchLoading(false);
      });
    } catch (e) {
      _handleSearchError('Failed to search products: $e');
    }
  }

  Future<void> loadMoreSearchResults() async {
    if (!_isSearchLoading.value && _hasMoreData.value && _isSearched.value) {
      await _searchForProducts(searchController.text, isLoadMore: true);
    }
  }

  void clearSearch() {
    searchController.clear();
    _isSearched.value = false;
    clearSearchResults();
  }

  void clearSearchResults() {
    _searchProducts.clear();
    _isSearchLoading.value = false;
    _hasMoreData.value = true;
    _currentPage.value = 1;
    _isSearchPageDataEmpty.value = false;
  }

  void onRecentSearchTap(String searchTerm) {
    performSearch(value: searchTerm);
  }

  Future<void> refreshData() async {
    clearSearchResults();
    await fetchSearchData(forceRefresh: true);
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  void _setSearchLoading(bool value) {
    _isSearchLoading.value = value;
  }

  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }

  void _handleFailure(Failure failure) {
    _setLoading(false);
    _handleError(failure.message);
  }

  void _handleSearchFailure(Failure failure) {
    _setSearchLoading(false);
    _handleSearchError(failure.message);
  }

  void _handleError(String message) {
    _hasError.value = true;
    _errorMessage.value = message;
    _setLoading(false);
  }

  void _handleSearchError(String message) {
    _setSearchLoading(false);
    // For search errors, we might want to handle them differently
    // For now, just stop loading
  }
}
