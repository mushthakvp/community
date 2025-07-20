import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/coupons_data.dart';

abstract class CouponsRepository {
  Future<Either<Failure, CouponsData>> getCoupons({
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, bool>> applyCoupon({required String couponId});
}
