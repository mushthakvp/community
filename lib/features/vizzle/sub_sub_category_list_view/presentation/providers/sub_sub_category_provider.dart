import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/vizzle_entities.dart';
import '../../../domain/usecases/get_sub_sub_categories_usecase.dart';

enum SubSubCategoryStatus { initial, loading, loaded, error }

class SubSubCategoryProvider extends ChangeNotifier {
  final GetSubSubCategoriesUseCase _getSubSubCategoriesUseCase;

  SubSubCategoryProvider({
    required GetSubSubCategoriesUseCase getSubSubCategoriesUseCase,
  }) : _getSubSubCategoriesUseCase = getSubSubCategoriesUseCase;

  // State
  SubSubCategoryStatus _status = SubSubCategoryStatus.initial;
  List<SubSubCategoryEntity> _subSubCategories = [];
  String? _errorMessage;

  // Cache
  DateTime? _lastLoadTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  // Getters
  SubSubCategoryStatus get status => _status;
  List<SubSubCategoryEntity> get subSubCategories => _subSubCategories;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == SubSubCategoryStatus.loading;
  bool get hasError => _status == SubSubCategoryStatus.error;
  bool get hasData => _subSubCategories.isNotEmpty;
  bool get isEmpty => _subSubCategories.isEmpty;

  // Public methods
  Future<void> loadSubSubCategories({
    required String subCategoryId,
    bool forceRefresh = false,
  }) async {
    if (_status == SubSubCategoryStatus.loading) return;

    if (forceRefresh || !_shouldUseCachedData()) {
      _setLoading();
      await _fetchSubSubCategories(subCategoryId);
    } else if (_subSubCategories.isNotEmpty) {
      _setLoaded();
    }
  }

  Future<void> refreshData(String subCategoryId) async {
    await loadSubSubCategories(
      subCategoryId: subCategoryId,
      forceRefresh: true,
    );
  }

  // Private methods
  Future<void> _fetchSubSubCategories(String subCategoryId) async {
    try {
      final result = await _getSubSubCategoriesUseCase(subCategoryId);

      result.fold((failure) => _setError(_getErrorMessage(failure)), (
        subSubCategories,
      ) {
        _subSubCategories = subSubCategories;
        _lastLoadTime = DateTime.now();
        _setLoaded();
      });
    } catch (e) {
      dev.log('Error fetching sub subcategories: $e');
      _setError('Failed to load sub subcategories. Please try again.');
    }
  }

  void _setLoading() {
    _status = SubSubCategoryStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoaded() {
    _status = SubSubCategoryStatus.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = SubSubCategoryStatus.error;
    _errorMessage = message;
    dev.log('Sub sub category provider error: $message');
    notifyListeners();
  }

  bool _shouldUseCachedData() {
    return _subSubCategories.isNotEmpty &&
        _lastLoadTime != null &&
        DateTime.now().difference(_lastLoadTime!) < _cacheValidDuration;
  }

  String _getErrorMessage(Failure failure) {
    return failure.userFriendlyMessage;
  }
}
