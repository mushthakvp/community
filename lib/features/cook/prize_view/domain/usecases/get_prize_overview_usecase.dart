import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/prize_overview.dart';
import '../repositories/prize_overview_repository.dart';

class GetPrizeOverviewUseCase
    implements UseCase<PrizeOverview, GetPrizeOverviewParams> {
  final PrizeOverviewRepository repository;

  GetPrizeOverviewUseCase(this.repository);

  @override
  Future<Either<Failure, PrizeOverview>> call(
    GetPrizeOverviewParams params,
  ) async {
    return await repository.getPrizeOverview(params.challengeId);
  }
}

class GetPrizeOverviewParams extends Equatable {
  final String challengeId;

  const GetPrizeOverviewParams({required this.challengeId});

  @override
  List<Object> get props => [challengeId];
}
