import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/coupons_data.dart';
import '../repositories/coupons_repository.dart';

class GetCoupons implements UseCase<CouponsData, GetCouponsParams> {
  final CouponsRepository repository;

  GetCoupons(this.repository);

  @override
  Future<Either<Failure, CouponsData>> call(GetCouponsParams params) async {
    return await repository.getCoupons(page: params.page, limit: params.limit);
  }
}

class GetCouponsParams {
  final int page;
  final int limit;
  final bool isLoadMore;

  const GetCouponsParams({
    this.page = 1,
    this.limit = 10,
    this.isLoadMore = false,
  });
}
