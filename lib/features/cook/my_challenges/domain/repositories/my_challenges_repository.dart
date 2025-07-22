import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/my_challenge.dart';

abstract class MyChallengesRepository {
  Future<Either<Failure, List<MyChallenge>>> getMyChallenges({
    required String status,
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, bool>> joinChallenge(String challengeId);

  Future<Either<Failure, bool>> submitRecipe({
    required String challengeId,
    required Map<String, dynamic> recipeData,
  });
}
