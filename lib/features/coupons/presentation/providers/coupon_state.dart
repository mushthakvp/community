import 'package:equatable/equatable.dart';

import '../../data/models/coupon_model.dart';

abstract class CouponState extends Equatable {
  const CouponState();

  @override
  List<Object?> get props => [];
}

class CouponInitial extends CouponState {}

class CouponLoading extends CouponState {}

class CouponLoaded extends CouponState {
  final GetCouponsModel coupons;
  final List<CouponReward> filteredCoupons;
  final List<CategoryElement> categories;
  final List<AppElement> apps;
  final String selectedCategoryId;
  final String selectedAppId;
  final String searchQuery;

  const CouponLoaded({
    required this.coupons,
    required this.filteredCoupons,
    required this.categories,
    required this.apps,
    required this.selectedCategoryId,
    required this.selectedAppId,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [
    coupons,
    filteredCoupons,
    categories,
    apps,
    selectedCategoryId,
    selectedAppId,
    searchQuery,
  ];

  CouponLoaded copyWith({
    GetCouponsModel? coupons,
    List<CouponReward>? filteredCoupons,
    List<CategoryElement>? categories,
    List<AppElement>? apps,
    String? selectedCategoryId,
    String? selectedAppId,
    String? searchQuery,
  }) {
    return CouponLoaded(
      coupons: coupons ?? this.coupons,
      filteredCoupons: filteredCoupons ?? this.filteredCoupons,
      categories: categories ?? this.categories,
      apps: apps ?? this.apps,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedAppId: selectedAppId ?? this.selectedAppId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class CouponError extends CouponState {
  final String message;
  final bool canRetry;

  const CouponError({required this.message, this.canRetry = true});

  @override
  List<Object?> get props => [message, canRetry];
}

class CouponActionLoading extends CouponState {
  final String couponId;
  final String action;

  const CouponActionLoading({required this.couponId, required this.action});

  @override
  List<Object?> get props => [couponId, action];
}

class CouponActionSuccess extends CouponState {
  final String message;

  const CouponActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class CouponActionError extends CouponState {
  final String message;

  const CouponActionError({required this.message});

  @override
  List<Object?> get props => [message];
}
