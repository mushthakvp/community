import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/vizzle_entities.dart';
import '../../../domain/usecases/get_sub_items_usecase.dart';

enum SubItemsStatus { initial, loading, loaded, error }

class SubItemsProvider extends ChangeNotifier {
  final GetSubItemsUseCase _getSubItemsUseCase;

  SubItemsProvider({required GetSubItemsUseCase getSubItemsUseCase})
    : _getSubItemsUseCase = getSubItemsUseCase;

  // State
  SubItemsStatus _status = SubItemsStatus.initial;
  List<SubItemEntity> _subItems = [];
  String? _errorMessage;

  // Cache
  DateTime? _lastLoadTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  // Getters
  SubItemsStatus get status => _status;
  List<SubItemEntity> get subItems => _subItems;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == SubItemsStatus.loading;
  bool get hasError => _status == SubItemsStatus.error;
  bool get hasData => _subItems.isNotEmpty;
  bool get isEmpty => _subItems.isEmpty;

  // Public methods
  Future<void> loadSubItems({
    required String subSubCategoryId,
    bool forceRefresh = false,
  }) async {
    if (_status == SubItemsStatus.loading) return;

    if (forceRefresh || !_shouldUseCachedData()) {
      _setLoading();
      await _fetchSubItems(subSubCategoryId);
    } else if (_subItems.isNotEmpty) {
      _setLoaded();
    }
  }

  void setSubItemsDirectly(List<SubItemEntity> subItems) {
    _subItems = subItems;
    _status = SubItemsStatus.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> refreshData(String subSubCategoryId) async {
    await loadSubItems(subSubCategoryId: subSubCategoryId, forceRefresh: true);
  }

  // Private methods
  Future<void> _fetchSubItems(String subSubCategoryId) async {
    try {
      final result = await _getSubItemsUseCase(subSubCategoryId);

      result.fold((failure) => _setError(_getErrorMessage(failure)), (
        subItems,
      ) {
        _subItems = subItems;
        _lastLoadTime = DateTime.now();
        _setLoaded();
      });
    } catch (e) {
      dev.log('Error fetching sub items: $e');
      _setError('Failed to load sub items. Please try again.');
    }
  }

  void _setLoading() {
    _status = SubItemsStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoaded() {
    _status = SubItemsStatus.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = SubItemsStatus.error;
    _errorMessage = message;
    dev.log('Sub items provider error: $message');
    notifyListeners();
  }

  bool _shouldUseCachedData() {
    return _subItems.isNotEmpty &&
        _lastLoadTime != null &&
        DateTime.now().difference(_lastLoadTime!) < _cacheValidDuration;
  }

  String _getErrorMessage(Failure failure) {
    return failure.userFriendlyMessage;
  }
}
