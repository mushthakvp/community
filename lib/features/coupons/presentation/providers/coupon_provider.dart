// lib/features/coupons/presentation/providers/coupon_provider.dart
import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/coupon_entity.dart';
import '../../domain/repositories/coupon_repository.dart';

enum CouponStatus { initial, loading, loaded, error, refreshing }

class CouponProvider extends ChangeNotifier {
  final CouponRepository _repository;

  CouponProvider({required CouponRepository repository})
    : _repository = repository;

  // State
  CouponStatus _status = CouponStatus.initial;
  List<CouponEntity> _coupons = [];
  List<CouponEntity> _filteredCoupons = [];
  List<CategoryEntity> _categories = [];
  List<AppEntity> _apps = [];
  String? _errorMessage;

  // Filters
  String _selectedCategoryId = 'all';
  String _selectedAppId = '';
  String _searchQuery = '';

  // Controllers
  final searchController = TextEditingController();
  Timer? _searchDebounce;

  // Cache
  DateTime? _lastLoadTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  // Getters
  CouponStatus get status => _status;
  List<CouponEntity> get coupons => _filteredCoupons;
  List<CategoryEntity> get categories => _categories;
  List<AppEntity> get apps => _apps;
  String? get errorMessage => _errorMessage;
  String get selectedCategoryId => _selectedCategoryId;
  String get selectedAppId => _selectedAppId;
  String get searchQuery => _searchQuery;
  bool get isLoading => _status == CouponStatus.loading;
  bool get hasError => _status == CouponStatus.error;
  bool get isEmpty => _filteredCoupons.isEmpty;
  bool get hasData => _filteredCoupons.isNotEmpty;

  @override
  void dispose() {
    searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  // Public Methods
  Future<void> initializeCoupons() async {
    if (_shouldUseCachedData()) {
      _applyFilters();
      return;
    }
    await loadCoupons();
  }

  Future<void> loadCoupons({bool forceRefresh = false}) async {
    if (_status == CouponStatus.loading) return;

    if (forceRefresh || !_shouldUseCachedData()) {
      _setLoading();
      await _fetchCoupons();
    } else {
      _applyFilters();
      _setLoaded();
    }
  }

  Future<void> refreshCoupons() async {
    _setRefreshing();
    await _fetchCoupons();
  }

  Future<void> loadCategories() async {
    try {
      final result = await _repository.getCategories();
      result.fold(
        (failure) => dev.log('Failed to load categories: ${failure.message}'),
        (categories) {
          _categories = [
            const CategoryEntity(id: 'all', name: 'All'),
            ...categories,
          ];
          notifyListeners();
        },
      );
    } catch (e) {
      dev.log('Error loading categories: $e');
    }
  }

  Future<void> loadApps() async {
    try {
      final result = await _repository.getApps();
      result.fold(
        (failure) => dev.log('Failed to load apps: ${failure.message}'),
        (apps) {
          _apps = apps;
          notifyListeners();
        },
      );
    } catch (e) {
      dev.log('Error loading apps: $e');
    }
  }

  void onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void selectCategory(String categoryId) {
    if (_selectedCategoryId != categoryId) {
      _selectedCategoryId = categoryId;
      _applyFilters();
    }
  }

  void selectApp(String appId) {
    if (_selectedAppId != appId) {
      _selectedAppId = appId;
      _applyFilters();
    }
  }

  void clearFilters() {
    _selectedCategoryId = 'all';
    _selectedAppId = '';
    _searchQuery = '';
    searchController.clear();
    _applyFilters();
  }

  Future<void> likeCoupon(String couponId) async {
    try {
      final result = await _repository.likeCoupon(couponId);
      result.fold((failure) => _showError(failure.message), (success) {
        if (success) {
          _updateCouponInList(
            couponId,
            (coupon) => coupon.copyWith(
              isLiked: true,
              isDisliked: false,
              likes: coupon.likes + 1,
            ),
          );
        }
      });
    } catch (e) {
      dev.log('Error liking coupon: $e');
      _showError('Failed to like coupon. Please try again.');
    }
  }

  Future<void> dislikeCoupon(String couponId, String reason) async {
    try {
      final result = await _repository.dislikeCoupon(couponId, reason);
      result.fold((failure) => _showError(failure.message), (success) {
        if (success) {
          _updateCouponInList(
            couponId,
            (coupon) => coupon.copyWith(
              isDisliked: true,
              isLiked: false,
              dislikes: coupon.dislikes + 1,
            ),
          );
        }
      });
    } catch (e) {
      dev.log('Error disliking coupon: $e');
      _showError('Failed to dislike coupon. Please try again.');
    }
  }

  Future<void> useCoupon(String couponId) async {
    try {
      final result = await _repository.useCoupon(couponId);
      result.fold((failure) => _showError(failure.message), (success) {
        if (success) {
          _updateCouponInList(
            couponId,
            (coupon) => coupon.copyWith(
              usageCount: coupon.usageCount + 1,
              lastUsed: DateTime.now(),
            ),
          );
        }
      });
    } catch (e) {
      dev.log('Error using coupon: $e');
      _showError('Failed to use coupon. Please try again.');
    }
  }

  String formatLastUsedTime(DateTime? lastUsed) {
    if (lastUsed == null) return "Never used";
    return lastUsed.timeAgo();
  }

  // Private Methods
  Future<void> _fetchCoupons() async {
    try {
      final result = await _repository.getCoupons(
        categoryId: _selectedCategoryId != 'all' ? _selectedCategoryId : null,
        appId: _selectedAppId.isNotEmpty ? _selectedAppId : null,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );

      result.fold((failure) => _setError(_getErrorMessage(failure)), (coupons) {
        _coupons = coupons;
        _lastLoadTime = DateTime.now();
        _applyFilters();
        _setLoaded();
      });
    } catch (e) {
      dev.log('Error fetching coupons: $e');
      _setError('Failed to load coupons. Please try again.');
    }
  }

  void _setLoading() {
    _status = CouponStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setRefreshing() {
    _status = CouponStatus.refreshing;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoaded() {
    _status = CouponStatus.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = CouponStatus.error;
    _errorMessage = message;
    dev.log('Coupon provider error: $message');
    notifyListeners();
  }

  void _showError(String message) {
    _errorMessage = message;
    notifyListeners();

    // Clear error after some time
    Timer(const Duration(seconds: 3), () {
      if (_errorMessage == message) {
        _errorMessage = null;
        notifyListeners();
      }
    });
  }

  void _applyFilters() {
    _filteredCoupons = _coupons.where((coupon) {
      // Category filter
      if (_selectedCategoryId != 'all' &&
          coupon.category.id != _selectedCategoryId) {
        return false;
      }

      // App filter
      if (_selectedAppId.isNotEmpty && coupon.app.id != _selectedAppId) {
        return false;
      }

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final description = coupon.description.toLowerCase();
        final appName = coupon.app.name.toLowerCase();
        final categoryName = coupon.category.name.toLowerCase();
        final couponCode = coupon.couponCode.toLowerCase();

        if (!description.contains(searchLower) &&
            !appName.contains(searchLower) &&
            !categoryName.contains(searchLower) &&
            !couponCode.contains(searchLower)) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sort coupons (newest first, then by likes)
    _filteredCoupons.sort((a, b) {
      final dateComparison = b.createdAt.compareTo(a.createdAt);
      if (dateComparison != 0) return dateComparison;
      return b.likes.compareTo(a.likes);
    });

    notifyListeners();
  }

  void _updateCouponInList(
    String couponId,
    CouponEntity Function(CouponEntity) updater,
  ) {
    final index = _coupons.indexWhere((coupon) => coupon.id == couponId);
    if (index != -1) {
      _coupons[index] = updater(_coupons[index]);
      _applyFilters();
    }
  }

  bool _shouldUseCachedData() {
    return _coupons.isNotEmpty &&
        _lastLoadTime != null &&
        DateTime.now().difference(_lastLoadTime!) < _cacheValidDuration;
  }

  String _getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return 'No internet connection. Please check your network.';
      case ServerFailure:
        return failure.message.isNotEmpty
            ? failure.message
            : 'Server error. Please try again later.';
      case ValidationFailure:
        return failure.message;
      case CacheFailure:
        return 'Cache error. Please refresh the app.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  // Debug methods (for development)
  void debugPrintCoupons() {
    dev.log('Total coupons: ${_coupons.length}');
    dev.log('Filtered coupons: ${_filteredCoupons.length}');
    dev.log('Selected category: $_selectedCategoryId');
    dev.log('Selected app: $_selectedAppId');
    dev.log('Search query: $_searchQuery');
  }
}
