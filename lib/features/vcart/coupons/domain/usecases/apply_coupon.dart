import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/coupons_repository.dart';

class ApplyCouponUseCase implements UseCase<bool, ApplyCouponUseCaseParams> {
  final CouponsRepository repository;

  ApplyCouponUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ApplyCouponUseCaseParams params) async {
    return await repository.applyCoupon(couponId: params.couponId);
  }
}

class ApplyCouponUseCaseParams {
  final String couponId;

  const ApplyCouponUseCaseParams({required this.couponId});
}
