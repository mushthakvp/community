import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../address/domain/entities/address.dart';
import '../repositories/checkout_repository.dart';

class GetCheckoutData implements UseCase<List<Address>, GetCheckoutDataParams> {
  final CheckoutRepository repository;

  GetCheckoutData(this.repository);

  @override
  Future<Either<Failure, List<Address>>> call(
    GetCheckoutDataParams params,
  ) async {
    return await repository.getAddresses(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetCheckoutDataParams {
  final int page;
  final int limit;

  const GetCheckoutDataParams({this.page = 1, this.limit = 10});
}
