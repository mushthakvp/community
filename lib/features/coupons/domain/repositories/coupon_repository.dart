import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/coupon_model.dart';

abstract class CouponRepository {
  Future<Either<Failure, GetCouponsModel>> getCoupons({
    String? categoryId,
    String? appId,
    String? search,
  });

  Future<Either<Failure, bool>> actionOnCoupon(
    String couponId,
    String action, [
    String? reason,
  ]);

  Future<Either<Failure, bool>> useCoupon(String couponId);
}
