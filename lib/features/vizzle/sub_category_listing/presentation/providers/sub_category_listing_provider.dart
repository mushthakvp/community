import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/vizzle_entities.dart';
import '../../../domain/usecases/get_categories_usecase.dart';
import '../../../domain/usecases/get_sub_categories_usecase.dart';

enum SubCategoryListingStatus { initial, loading, loaded, error }

class SubCategoryListingProvider extends ChangeNotifier {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetSubCategoriesUseCase _getSubCategoriesUseCase;

  SubCategoryListingProvider({
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetSubCategoriesUseCase getSubCategoriesUseCase,
  }) : _getCategoriesUseCase = getCategoriesUseCase,
       _getSubCategoriesUseCase = getSubCategoriesUseCase;

  // State
  SubCategoryListingStatus _status = SubCategoryListingStatus.initial;
  List<SubCategoryEntity> _subCategories = [];
  String _categoryId = '';
  String _currentCategoryName = ''; // Track current category
  String? _errorMessage;

  // Cache with category-specific keys
  final Map<String, List<SubCategoryEntity>> _categoryCache = {};
  final Map<String, String> _categoryIdCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  // Getters
  SubCategoryListingStatus get status => _status;
  List<SubCategoryEntity> get subCategories => _subCategories;
  String get categoryId => _categoryId;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == SubCategoryListingStatus.loading;
  bool get hasError => _status == SubCategoryListingStatus.error;
  bool get hasData => _subCategories.isNotEmpty;
  bool get isEmpty => _subCategories.isEmpty;

  // Public methods
  Future<void> loadSubCategories({
    required String categoryName,
    bool forceRefresh = false,
  }) async {
    // If we're already loading the same category, don't start another request
    if (_status == SubCategoryListingStatus.loading &&
        _currentCategoryName == categoryName) {
      return;
    }

    // If this is a different category, always force refresh
    if (_currentCategoryName != categoryName) {
      forceRefresh = true;
      _currentCategoryName = categoryName;
    }

    // Check if we have valid cached data for this category
    if (!forceRefresh && _shouldUseCachedData(categoryName)) {
      _loadFromCache(categoryName);
      return;
    }

    // Load fresh data
    _setLoading();
    await _fetchSubCategories(categoryName);
  }

  Future<void> refreshData(String categoryName) async {
    _currentCategoryName = categoryName;
    await loadSubCategories(categoryName: categoryName, forceRefresh: true);
  }

  // Clear cache when needed (e.g., on app restart or manual cache clear)
  void clearCache() {
    _categoryCache.clear();
    _categoryIdCache.clear();
    _cacheTimestamps.clear();
  }

  // Private methods
  void _loadFromCache(String categoryName) {
    final cachedData = _categoryCache[categoryName];
    final cachedCategoryId = _categoryIdCache[categoryName];

    if (cachedData != null && cachedCategoryId != null) {
      _subCategories = cachedData;
      _categoryId = cachedCategoryId;
      _setLoaded();
      dev.log('Loaded subcategories from cache for: $categoryName');
    }
  }

  Future<void> _fetchSubCategories(String categoryName) async {
    try {
      dev.log('Fetching subcategories for: $categoryName');

      // First get all categories to find the category ID
      final categoriesResult = await _getCategoriesUseCase();

      await categoriesResult.fold(
        (failure) async => _setError(_getErrorMessage(failure)),
        (categories) async {
          final category = categories.firstWhere(
            (cat) => cat.name.toLowerCase() == categoryName.toLowerCase(),
            orElse: () =>
                const CategoryEntity(id: '', name: '', subcategories: []),
          );

          if (category.id.isEmpty) {
            _setError('Category "$categoryName" not found');
            return;
          }

          _categoryId = category.id;

          dev.log('Found category ID: ${category.id} for: $categoryName');

          // Now get subcategories for this category
          final subCategoriesResult = await _getSubCategoriesUseCase(
            category.id,
          );

          subCategoriesResult.fold(
            (failure) => _setError(_getErrorMessage(failure)),
            (subCategories) {
              _subCategories = subCategories;

              // Cache the results
              _categoryCache[categoryName] = subCategories;
              _categoryIdCache[categoryName] = category.id;
              _cacheTimestamps[categoryName] = DateTime.now();

              dev.log(
                'Loaded ${subCategories.length} subcategories for: $categoryName',
              );
              _setLoaded();
            },
          );
        },
      );
    } catch (e) {
      dev.log('Error fetching subcategories: $e');
      _setError('Failed to load subcategories. Please try again.');
    }
  }

  void _setLoading() {
    _status = SubCategoryListingStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoaded() {
    _status = SubCategoryListingStatus.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = SubCategoryListingStatus.error;
    _errorMessage = message;
    dev.log('Sub category listing provider error: $message');
    notifyListeners();
  }

  bool _shouldUseCachedData(String categoryName) {
    final cacheTime = _cacheTimestamps[categoryName];
    final cachedData = _categoryCache[categoryName];

    return cachedData != null &&
        cachedData.isNotEmpty &&
        cacheTime != null &&
        DateTime.now().difference(cacheTime) < _cacheValidDuration;
  }

  String _getErrorMessage(Failure failure) {
    return failure.userFriendlyMessage;
  }

  void navigateToSubCategory(String subCategoryName) {
    dev.log('Navigating to subcategory: $subCategoryName');
  }
}
