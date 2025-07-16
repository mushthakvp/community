import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/saved_ads_repository.dart';

class ToggleSavedFavoriteUseCase
    implements UseCase<void, ToggleSavedFavoriteParams> {
  final SavedAdsRepository repository;

  ToggleSavedFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleSavedFavoriteParams params) async {
    return await repository.toggleFavorite(params.adId);
  }
}

class ToggleSavedFavoriteParams extends Equatable {
  final String adId;

  const ToggleSavedFavoriteParams({required this.adId});

  @override
  List<Object> get props => [adId];
}
