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
  String? _errorMessage;

  // Cache
  DateTime? _lastLoadTime;
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
    if (_status == SubCategoryListingStatus.loading) return;

    if (forceRefresh || !_shouldUseCachedData()) {
      _setLoading();
      await _fetchSubCategories(categoryName);
    } else if (_subCategories.isNotEmpty) {
      _setLoaded();
    }
  }

  Future<void> refreshData(String categoryName) async {
    await loadSubCategories(categoryName: categoryName, forceRefresh: true);
  }

  // Private methods
  Future<void> _fetchSubCategories(String categoryName) async {
    try {
      // First get all categories to find the category ID
      final categoriesResult = await _getCategoriesUseCase();

      await categoriesResult.fold(
        (failure) async => _setError(_getErrorMessage(failure)),
        (categories) async {
          final category = categories.firstWhere(
            (cat) => cat.name == categoryName,
            orElse: () =>
                const CategoryEntity(id: '', name: '', subcategories: []),
          );

          if (category.id.isEmpty) {
            _setError('Category not found');
            return;
          }

          _categoryId = category.id;

          // Now get subcategories for this category
          final subCategoriesResult = await _getSubCategoriesUseCase(
            category.id,
          );

          subCategoriesResult.fold(
            (failure) => _setError(_getErrorMessage(failure)),
            (subCategories) {
              _subCategories = subCategories;
              _lastLoadTime = DateTime.now();
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

  bool _shouldUseCachedData() {
    return _subCategories.isNotEmpty &&
        _lastLoadTime != null &&
        DateTime.now().difference(_lastLoadTime!) < _cacheValidDuration;
  }

  String _getErrorMessage(Failure failure) {
    return failure.userFriendlyMessage;
  }
}
