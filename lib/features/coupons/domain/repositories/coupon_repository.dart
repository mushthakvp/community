import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/coupon_entity.dart';

abstract class CouponRepository {
  Future<Either<Failure, List<CouponEntity>>> getCoupons({
    String? categoryId,
    String? appId,
    String? search,
  });

  Future<Either<Failure, bool>> likeCoupon(String couponId);

  Future<Either<Failure, bool>> dislikeCoupon(String couponId, String reason);

  Future<Either<Failure, bool>> useCoupon(String couponId);

  Future<Either<Failure, List<CategoryEntity>>> getCategories();

  Future<Either<Failure, List<AppEntity>>> getApps();
}
