import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/error/failures.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../domain/entities/coupon.dart';
import '../../domain/entities/coupons_data.dart';
import '../../domain/usecases/apply_coupon.dart';
import '../../domain/usecases/get_coupons.dart';

class VCartCouponsController extends GetxController {
  final GetCoupons getCouponsUseCase;
  final ApplyCouponUseCase applyCouponUseCase;

  VCartCouponsController({
    required this.getCouponsUseCase,
    required this.applyCouponUseCase,
  });

  // Observable variables
  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _isApplying = false.obs;
  final _coupons = <Coupon>[].obs;
  final _appliedCouponId = ''.obs;
  final _errorMessage = ''.obs;
  final _hasError = false.obs;
  final _hasMoreData = true.obs;
  final _currentPage = 1.obs;
  final _isEmpty = false.obs;

  // Constants
  final int _itemsPerPage = 10;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get isApplying => _isApplying.value;
  List<Coupon> get coupons => _coupons;
  String get appliedCouponId => _appliedCouponId.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _hasError.value;
  bool get hasMoreData => _hasMoreData.value;
  bool get isEmpty => _isEmpty.value;

  @override
  void onInit() {
    super.onInit();
    loadCoupons();
  }

  Future<void> loadCoupons({bool isLoadMore = false}) async {
    try {
      if (!isLoadMore) {
        _currentPage.value = 1;
        _coupons.clear();
        _hasMoreData.value = true;
        _isEmpty.value = false;
        _setLoading(true);
      } else {
        if (!_hasMoreData.value) return;
        _setLoadingMore(true);
      }

      _clearError();

      final result = await getCouponsUseCase(
        GetCouponsParams(
          page: _currentPage.value,
          limit: _itemsPerPage,
          isLoadMore: isLoadMore,
        ),
      );

      result.fold(
        (failure) => _handleFailure(failure, isLoadMore),
        (data) => _handleCouponsSuccess(data, isLoadMore),
      );
    } catch (e) {
      _handleError('Unexpected error occurred: $e', isLoadMore);
    }
  }

  void _handleCouponsSuccess(CouponsData data, bool isLoadMore) {
    if (data.coupons.isEmpty && !isLoadMore) {
      _isEmpty.value = true;
    } else {
      _coupons.addAll(data.coupons);
      _isEmpty.value = false;

      // Check if there are more pages
      if (data.coupons.length < _itemsPerPage || !data.hasMorePages) {
        _hasMoreData.value = false;
      } else {
        _currentPage.value++;
      }
    }

    if (isLoadMore) {
      _setLoadingMore(false);
    } else {
      _setLoading(false);
    }
  }

  Future<void> refreshCoupons() async {
    await loadCoupons();
  }

  Future<void> loadMoreCoupons() async {
    await loadCoupons(isLoadMore: true);
  }

  Future<void> applyCoupon(String couponId, BuildContext context) async {
    try {
      _setApplying(true);
      _appliedCouponId.value = couponId;

      final result = await applyCouponUseCase(
        ApplyCouponUseCaseParams(couponId: couponId),
      );

      result.fold(
        (failure) {
          _setApplying(false);
          _appliedCouponId.value = '';
          context.showVCartSnackBar(failure.message, isError: true);
        },
        (success) {
          _setApplying(false);
          if (success) {
            context.showVCartSnackBar('Coupon applied successfully');
            // Return the coupon ID to the previous screen
            Get.back(result: couponId);
          } else {
            _appliedCouponId.value = '';
            context.showVCartSnackBar('Failed to apply coupon', isError: true);
          }
        },
      );
    } catch (e) {
      _setApplying(false);
      _appliedCouponId.value = '';
      context.showVCartSnackBar(
        'Something went wrong. Please try again.',
        isError: true,
      );
    }
  }

  bool isCouponApplied(String couponId) {
    return _appliedCouponId.value == couponId;
  }

  void clearAppliedCoupon() {
    _appliedCouponId.value = '';
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  void _setLoadingMore(bool value) {
    _isLoadingMore.value = value;
  }

  void _setApplying(bool value) {
    _isApplying.value = value;
  }

  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }

  void _handleFailure(Failure failure, bool isLoadMore) {
    if (isLoadMore) {
      _setLoadingMore(false);
    } else {
      _setLoading(false);
    }
    _handleError(failure.message, isLoadMore);
  }

  void _handleError(String message, bool isLoadMore) {
    _hasError.value = true;
    _errorMessage.value = message;

    if (isLoadMore) {
      _setLoadingMore(false);
    } else {
      _setLoading(false);
    }
  }
}
