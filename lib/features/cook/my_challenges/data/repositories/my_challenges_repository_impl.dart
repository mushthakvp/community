import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/my_challenge.dart';
import '../../domain/repositories/my_challenges_repository.dart';
import '../datasources/my_challenges_remote_data_source.dart';

class MyChallengesRepositoryImpl implements MyChallengesRepository {
  final MyChallengesRemoteDataSource remoteDataSource;

  MyChallengesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MyChallenge>>> getMyChallenges({
    required String status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final result = await remoteDataSource.getMyChallenges(
        status: status,
        page: page,
        limit: limit,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> joinChallenge(String challengeId) async {
    try {
      final result = await remoteDataSource.joinChallenge(challengeId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> submitRecipe({
    required String challengeId,
    required Map<String, dynamic> recipeData,
  }) async {
    try {
      final result = await remoteDataSource.submitRecipe(
        challengeId: challengeId,
        recipeData: recipeData,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
