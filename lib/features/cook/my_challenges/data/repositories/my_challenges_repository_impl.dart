import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/my_challenge.dart';
import '../../domain/repositories/my_challenges_repository.dart';
import '../datasources/my_challenges_local_data_source.dart';
import '../datasources/my_challenges_remote_data_source.dart';

class MyChallengesRepositoryImpl implements MyChallengesRepository {
  final MyChallengesRemoteDataSource remoteDataSource;
  final MyChallengesLocalDataSource localDataSource;

  MyChallengesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<MyChallenge>>> getMyChallenges({
    required String status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      // Try cache first for page 1
      if (page == 1) {
        final cachedData = await localDataSource.getCachedMyChallenges(status);
        if (cachedData != null) {
          return Right(cachedData);
        }
      }

      // Fetch from remote
      final result = await remoteDataSource.getMyChallenges(
        status: status,
        page: page,
        limit: limit,
      );

      // Cache first page
      if (page == 1) {
        await localDataSource.cacheMyChallenges(status, result);
      }

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
      // Clear cache to refresh data
      await localDataSource.clearMyChallengesCache();
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
      // Clear cache to refresh data
      await localDataSource.clearMyChallengesCache();
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
