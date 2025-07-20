import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/cart_data.dart';
import '../repositories/cart_repository.dart';

class ApplyCoupon implements UseCase<CartData, ApplyCouponParams> {
  final CartRepository repository;

  ApplyCoupon(this.repository);

  @override
  Future<Either<Failure, CartData>> call(ApplyCouponParams params) async {
    return await repository.applyCoupon(couponId: params.couponId);
  }
}

class RemoveCoupon implements UseCase<CartData, NoParams> {
  final CartRepository repository;

  RemoveCoupon(this.repository);

  @override
  Future<Either<Failure, CartData>> call(NoParams params) async {
    return await repository.removeCoupon();
  }
}

class ApplyCouponParams {
  final String couponId;

  const ApplyCouponParams({required this.couponId});
}
