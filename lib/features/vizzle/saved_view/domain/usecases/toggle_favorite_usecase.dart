import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/saved_ads_repository.dart';

class ToggleFavoriteUseCase implements UseCase<void, ToggleFavoriteParams> {
  final SavedAdsRepository repository;

  ToggleFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleFavoriteParams params) async {
    return await repository.toggleFavorite(params.adId);
  }
}

class ToggleFavoriteParams extends Equatable {
  final String adId;

  const ToggleFavoriteParams({required this.adId});

  @override
  List<Object> get props => [adId];
}
