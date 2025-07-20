import 'package:equatable/equatable.dart';

import 'coupon.dart';

class CouponsData extends Equatable {
  final bool success;
  final String message;
  final List<Coupon> coupons;
  final int totalPages;
  final int totalCoupons;
  final int currentPage;

  const CouponsData({
    required this.success,
    required this.message,
    required this.coupons,
    required this.totalPages,
    required this.totalCoupons,
    required this.currentPage,
  });

  bool get isEmpty => coupons.isEmpty;
  bool get isNotEmpty => coupons.isNotEmpty;
  bool get hasMorePages => currentPage < totalPages;

  @override
  List<Object?> get props => [
    success,
    message,
    coupons,
    totalPages,
    totalCoupons,
    currentPage,
  ];
}
