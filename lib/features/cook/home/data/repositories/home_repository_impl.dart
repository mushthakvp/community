import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/cooking_home.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_data_source.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, CookingHome>> getCookingHome({
    String? search,
    int currentPage = 1,
    int currentLimit = 3,
    int upcomingPage = 1,
    int upcomingLimit = 10,
  }) async {
    try {
      // If search is provided, always fetch from remote
      if (search != null && search.isNotEmpty) {
        return await _fetchFromRemote(
          search: search,
          currentPage: currentPage,
          currentLimit: currentLimit,
          upcomingPage: upcomingPage,
          upcomingLimit: upcomingLimit,
        );
      }

      // For initial load (currentPage == 1), try cache first
      if (currentPage == 1) {
        final cachedData = await localDataSource.getCachedCookingHome();
        if (cachedData != null &&
            (cachedData.currentChallenges.isNotEmpty ||
                cachedData.upcomingChallenges.isNotEmpty)) {
          return Right(cachedData);
        }
      }

      // Always fetch from remote if no valid cache or not first page
      return await _fetchFromRemote(
        search: search,
        currentPage: currentPage,
        currentLimit: currentLimit,
        upcomingPage: upcomingPage,
        upcomingLimit: upcomingLimit,
        shouldCache: currentPage == 1,
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, CookingHome>> _fetchFromRemote({
    String? search,
    int currentPage = 1,
    int currentLimit = 3,
    int upcomingPage = 1,
    int upcomingLimit = 10,
    bool shouldCache = false,
  }) async {
    try {
      final result = await remoteDataSource.getCookingHome(
        search: search,
        currentPage: currentPage,
        currentLimit: currentLimit,
        upcomingPage: upcomingPage,
        upcomingLimit: upcomingLimit,
      );

      if (shouldCache && (search == null || search.isEmpty)) {
        await localDataSource.cacheCookingHome(result);
      }

      return Right(result);
    } catch (e) {
      rethrow;
    }
  }
}
