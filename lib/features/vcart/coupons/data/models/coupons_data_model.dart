import '../../domain/entities/coupons_data.dart';
import 'coupon_model.dart';

class CouponsDataModel extends CouponsData {
  const CouponsDataModel({
    required super.success,
    required super.message,
    required super.coupons,
    required super.totalPages,
    required super.totalCoupons,
    required super.currentPage,
  });

  factory CouponsDataModel.fromJson(Map<String, dynamic> json) {
    return CouponsDataModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      coupons:
          (json['coupons'] as List<dynamic>?)
              ?.map((e) => CouponModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalPages: json['totalPages'] ?? 0,
      totalCoupons: json['totalCoupons'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
    );
  }
}
