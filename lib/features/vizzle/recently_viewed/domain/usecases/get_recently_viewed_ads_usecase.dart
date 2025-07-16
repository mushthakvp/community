import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/recently_viewed_ad_entity.dart';
import '../repositories/recently_viewed_repository.dart';

class GetRecentlyViewedAdsUseCase
    implements UseCase<List<RecentlyViewedAdEntity>, NoParams> {
  final RecentlyViewedRepository repository;

  GetRecentlyViewedAdsUseCase(this.repository);

  @override
  Future<Either<Failure, List<RecentlyViewedAdEntity>>> call(
    NoParams params,
  ) async {
    return await repository.getRecentlyViewedAds();
  }
}
