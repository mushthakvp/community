import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../profile/domain/entities/advertisement_entity.dart';
import '../repositories/edit_ad_repository.dart';

class GetAdDetailsUseCase
    implements UseCase<AdvertisementEntity, GetAdDetailsParams> {
  final EditAdRepository repository;

  GetAdDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, AdvertisementEntity>> call(
    GetAdDetailsParams params,
  ) async {
    return await repository.getAdDetails(params.adId);
  }
}

class GetAdDetailsParams extends Equatable {
  final String adId;

  const GetAdDetailsParams({required this.adId});

  @override
  List<Object> get props => [adId];
}
