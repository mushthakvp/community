import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/recently_viewed_repository.dart';

class ToggleRecentlyViewedFavoriteUseCase
    implements UseCase<void, ToggleRecentlyViewedFavoriteParams> {
  final RecentlyViewedRepository repository;

  ToggleRecentlyViewedFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(
    ToggleRecentlyViewedFavoriteParams params,
  ) async {
    return await repository.toggleFavorite(params.adId);
  }
}

class ToggleRecentlyViewedFavoriteParams extends Equatable {
  final String adId;

  const ToggleRecentlyViewedFavoriteParams({required this.adId});

  @override
  List<Object> get props => [adId];
}
