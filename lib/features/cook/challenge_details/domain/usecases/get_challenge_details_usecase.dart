import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/challenge_details.dart';
import '../repositories/challenge_details_repository.dart';

class GetChallengeDetailsUseCase
    implements UseCase<ChallengeDetails, GetChallengeDetailsParams> {
  final ChallengeDetailsRepository repository;

  GetChallengeDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, ChallengeDetails>> call(
    GetChallengeDetailsParams params,
  ) async {
    return await repository.getChallengeDetails(params.challengeId);
  }
}

class GetChallengeDetailsParams extends Equatable {
  final String challengeId;

  const GetChallengeDetailsParams({required this.challengeId});

  @override
  List<Object> get props => [challengeId];
}
