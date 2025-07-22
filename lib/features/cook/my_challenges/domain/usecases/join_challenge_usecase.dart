import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/my_challenges_repository.dart';

class JoinChallengeUseCase implements UseCase<bool, JoinChallengeParams> {
  final MyChallengesRepository repository;

  JoinChallengeUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(JoinChallengeParams params) async {
    return await repository.joinChallenge(params.challengeId);
  }
}

class JoinChallengeParams extends Equatable {
  final String challengeId;

  const JoinChallengeParams({required this.challengeId});

  @override
  List<Object> get props => [challengeId];
}
