// lib/features/coupons/presentation/providers/coupon_provider.dart

import 'dart:async';
import 'dart:developer' as dev;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/coupon_model.dart';
import '../../data/repositories/coupon_repository_impl.dart';
import '../utils/date_formatter.dart';
import 'coupon_state.dart';

class CouponProvider extends ChangeNotifier {
  final CouponRepositoryImpl _repository;
  final Connectivity _connectivity;

  CouponProvider({
    required CouponRepositoryImpl repository,
    required Connectivity connectivity,
  }) : _repository = repository,
       _connectivity = connectivity;

  // State
  CouponState _state = CouponInitial();
  CouponState get state => _state;

  // Controllers
  final TextEditingController searchController = TextEditingController();
  final TextEditingController dislikeController = TextEditingController();

  // Debounce timer for search
  Timer? _searchDebounce;
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  // Cache
  GetCouponsModel? _cachedCoupons;
  DateTime? _lastCacheTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  @override
  void dispose() {
    searchController.dispose();
    dislikeController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  // Public Methods
  Future<void> initializeCoupons() async {
    if (_shouldUseCachedData()) {
      _emitLoadedState(_cachedCoupons!);
      return;
    }

    await loadCoupons();
  }

  Future<void> loadCoupons({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh && _shouldUseCachedData()) {
        _emitLoadedState(_cachedCoupons!);
        return;
      }

      _setState(CouponLoading());

      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _setState(
          const CouponError(
            message: 'No internet connection. Please check your network.',
            canRetry: true,
          ),
        );
        return;
      }

      final result = await _repository.getCoupons();

      result.fold(
        (failure) {
          dev.log('Failed to load coupons: ${failure.message}');
          _setState(
            CouponError(
              message: _getErrorMessage(failure),
              canRetry: failure is! ValidationFailure,
            ),
          );
        },
        (coupons) {
          _cachedCoupons = coupons;
          _lastCacheTime = DateTime.now();
          _emitLoadedState(coupons);
        },
      );
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in loadCoupons',
        error: e,
        stackTrace: stackTrace,
      );
      _setState(
        const CouponError(
          message: 'An unexpected error occurred. Please try again.',
          canRetry: true,
        ),
      );
    }
  }

  void onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_debounceDuration, () {
      _filterCoupons(query: query);
    });
  }

  void onCategorySelected(String categoryId) {
    _filterCoupons(categoryId: categoryId);
  }

  void onAppSelected(String appId) {
    _filterCoupons(appId: appId);
  }

  Future<void> likeCoupon(String couponId) async {
    await _performCouponAction(couponId, 'like');
  }

  Future<void> dislikeCoupon(String couponId, String reason) async {
    await _performCouponAction(couponId, 'dislike', reason: reason);
  }

  Future<void> useCoupon(String couponId) async {
    try {
      final result = await _repository.useCoupon(couponId);

      result.fold(
        (failure) {
          _setState(CouponActionError(message: _getErrorMessage(failure)));
        },
        (success) {
          // Refresh coupons to update usage count
          loadCoupons(forceRefresh: true);
        },
      );
    } catch (e) {
      dev.log('Error using coupon', error: e);
      _setState(
        const CouponActionError(
          message: 'Failed to use coupon. Please try again.',
        ),
      );
    }
  }

  String formatLastUsedTime(DateTime? lastUsed) {
    return DateFormatter.formatLastUsedTime(lastUsed);
  }

  // Private Methods
  void _setState(CouponState newState) {
    _state = newState;
    notifyListeners();
  }

  bool _shouldUseCachedData() {
    return _cachedCoupons != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _cacheValidDuration;
  }

  void _emitLoadedState(GetCouponsModel coupons) {
    final categories = _buildCategoriesWithAll(coupons.data?.categories ?? []);
    final currentState = _state;

    String selectedCategoryId = 'all';
    String selectedAppId = '';
    String searchQuery = '';

    if (currentState is CouponLoaded) {
      selectedCategoryId = currentState.selectedCategoryId;
      selectedAppId = currentState.selectedAppId;
      searchQuery = currentState.searchQuery;
    }

    final filteredCoupons = _filterCouponsList(
      coupons.data?.couponRewards ?? [],
      categoryId: selectedCategoryId,
      appId: selectedAppId,
      query: searchQuery,
    );

    _setState(
      CouponLoaded(
        coupons: coupons,
        filteredCoupons: filteredCoupons,
        categories: categories,
        apps: coupons.data?.apps ?? [],
        selectedCategoryId: selectedCategoryId,
        selectedAppId: selectedAppId,
        searchQuery: searchQuery,
      ),
    );
  }

  void _filterCoupons({String? categoryId, String? appId, String? query}) {
    final currentState = _state;
    if (currentState is! CouponLoaded) return;

    final newCategoryId = categoryId ?? currentState.selectedCategoryId;
    final newAppId = appId ?? currentState.selectedAppId;
    final newQuery = query ?? currentState.searchQuery;

    final filteredCoupons = _filterCouponsList(
      currentState.coupons.data?.couponRewards ?? [],
      categoryId: newCategoryId,
      appId: newAppId,
      query: newQuery,
    );

    _setState(
      currentState.copyWith(
        filteredCoupons: filteredCoupons,
        selectedCategoryId: newCategoryId,
        selectedAppId: newAppId,
        searchQuery: newQuery,
      ),
    );
  }

  List<CouponReward> _filterCouponsList(
    List<CouponReward> coupons, {
    required String categoryId,
    required String appId,
    required String query,
  }) {
    return coupons.where((coupon) {
      // Category filter
      if (categoryId != 'all' && coupon.category?.id != categoryId) {
        return false;
      }

      // App filter
      if (appId.isNotEmpty && coupon.app?.id != appId) {
        return false;
      }

      // Search filter
      if (query.isNotEmpty) {
        final searchLower = query.toLowerCase();
        final description = coupon.description?.toLowerCase() ?? '';
        final appName = coupon.app?.appName?.toLowerCase() ?? '';
        final categoryName = coupon.category?.name?.toLowerCase() ?? '';

        if (!description.contains(searchLower) &&
            !appName.contains(searchLower) &&
            !categoryName.contains(searchLower)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  List<CategoryElement> _buildCategoriesWithAll(
    List<CategoryElement> categories,
  ) {
    return [CategoryElement(id: 'all', name: 'All'), ...categories];
  }

  Future<void> _performCouponAction(
    String couponId,
    String action, {
    String? reason,
  }) async {
    try {
      _setState(CouponActionLoading(couponId: couponId, action: action));

      final result = await _repository.actionOnCoupon(couponId, action, reason);

      result.fold(
        (failure) {
          _setState(CouponActionError(message: _getErrorMessage(failure)));
        },
        (success) {
          _setState(
            CouponActionSuccess(message: 'Action completed successfully'),
          );
          // Clear dislike reason if it was a dislike action
          if (action == 'dislike') {
            dislikeController.clear();
          }
          // Refresh coupons to update like/dislike counts
          loadCoupons(forceRefresh: true);
        },
      );
    } catch (e) {
      dev.log('Error performing coupon action', error: e);
      _setState(
        CouponActionError(
          message: 'Failed to perform action. Please try again.',
        ),
      );
    }
  }

  String _getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return 'Network error. Please check your connection.';
      case ServerFailure:
        return 'Server error. Please try again later.';
      case ValidationFailure:
        return failure.message;
      case CacheFailure:
        return 'Cache error. Please refresh the app.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
