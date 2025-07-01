import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/ads_filter_entity.dart';
import '../entities/ads_response_entity.dart';
import '../repositories/ads_repository.dart';

class GetAdsUseCase implements UseCase<AdsResponseEntity, GetAdsParams> {
  final AdsRepository repository;

  GetAdsUseCase(this.repository);

  @override
  Future<Either<Failure, AdsResponseEntity>> call(GetAdsParams params) async {
    // Validate parameters
    if (params.page < 1) {
      return const Left(
        ValidationFailure(message: 'Page must be greater than 0'),
      );
    }
    if (params.limit < 1 || params.limit > 100) {
      return const Left(
        ValidationFailure(message: 'Limit must be between 1 and 100'),
      );
    }

    return await repository.getAds(
      page: params.page,
      limit: params.limit,
      filter: params.filter,
    );
  }
}

class GetAdsParams {
  final int page;
  final int limit;
  final AdsFilterEntity? filter;

  const GetAdsParams({required this.page, required this.limit, this.filter});
}
