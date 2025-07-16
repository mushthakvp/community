import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/saved_ad_entity.dart';
import '../repositories/saved_ads_repository.dart';

class GetSavedAdsUseCase implements UseCase<List<SavedAdEntity>, NoParams> {
  final SavedAdsRepository repository;

  GetSavedAdsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SavedAdEntity>>> call(NoParams params) async {
    return await repository.getSavedAds();
  }
}
