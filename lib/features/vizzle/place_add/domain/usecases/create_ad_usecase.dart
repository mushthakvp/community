import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/ad_creation.dart';
import '../repositories/place_add_repository.dart';

class CreateAdUseCase
    implements UseCase<AdCreationResponse, AdCreationRequest> {
  final PlaceAddRepository repository;

  CreateAdUseCase(this.repository);

  @override
  Future<Either<Failure, AdCreationResponse>> call(
    AdCreationRequest params,
  ) async {
    return await repository.createAd(params);
  }
}
