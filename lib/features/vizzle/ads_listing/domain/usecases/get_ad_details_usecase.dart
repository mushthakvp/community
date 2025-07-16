import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/ad_entity.dart';
import '../repositories/ads_repository.dart';

class GetAdDetailsUseCase implements UseCase<AdEntity, String> {
  final AdsRepository repository;

  GetAdDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, AdEntity>> call(String adId) async {
    if (adId.isEmpty) {
      return const Left(ValidationFailure(message: 'Ad ID cannot be empty'));
    }

    return await repository.getAdById(adId);
  }
}
