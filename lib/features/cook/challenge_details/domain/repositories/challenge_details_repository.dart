import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/challenge_details.dart';

abstract class ChallengeDetailsRepository {
  Future<Either<Failure, ChallengeDetails>> getChallengeDetails(
    String challengeId,
  );
  Future<Either<Failure, bool>> joinChallenge(String challengeId);
}
