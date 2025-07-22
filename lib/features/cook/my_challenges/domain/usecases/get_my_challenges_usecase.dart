import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/my_challenge.dart';
import '../repositories/my_challenges_repository.dart';

class GetMyChallengesUseCase
    implements UseCase<List<MyChallenge>, GetMyChallengesParams> {
  final MyChallengesRepository repository;

  GetMyChallengesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MyChallenge>>> call(
    GetMyChallengesParams params,
  ) async {
    return await repository.getMyChallenges(
      status: params.status,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetMyChallengesParams extends Equatable {
  final String status;
  final int page;
  final int limit;

  const GetMyChallengesParams({
    required this.status,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object> get props => [status, page, limit];
}
