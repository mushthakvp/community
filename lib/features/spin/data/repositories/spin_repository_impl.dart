import 'dart:developer' as dev;

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/spin_config_entity.dart';
import '../../domain/entities/spin_history_entity.dart';
import '../../domain/entities/spin_option_entity.dart';
import '../../domain/entities/spin_result_entity.dart';
import '../../domain/repositories/spin_repository.dart';
import '../datasources/spin_local_datasource.dart';
import '../datasources/spin_remote_datasource.dart';
import '../models/spin_option_model.dart';
import '../models/spin_result_model.dart';

class SpinRepositoryImpl implements SpinRepository {
  final SpinRemoteDataSource remoteDataSource;
  final SpinLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SpinRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SpinConfigEntity>> getSpinConfig(
    String spinType,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final config = await remoteDataSource.getSpinConfig(spinType);
        return Right(config.toEntity());
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getSpinConfig: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getSpinConfig: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getSpinConfig',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<SpinOptionEntity>>> getSpinOptions(
    String spinType,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final options = await remoteDataSource.getSpinOptions(spinType);

          // Cache the options
          await localDataSource.cacheSpinOptions(spinType, options);

          return Right(options.map((option) => option.toEntity()).toList());
        } catch (e) {
          // If remote fails, try cache
          return await _getCachedSpinOptions(spinType);
        }
      } else {
        // No internet, use cache
        return await _getCachedSpinOptions(spinType);
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getSpinOptions: ${e.message}');
      // Try cache as fallback
      final cacheResult = await _getCachedSpinOptions(spinType);
      return cacheResult.fold(
        (failure) => Left(ServerFailure(message: e.message)),
        (options) => Right(options),
      );
    } on NetworkException catch (e) {
      dev.log('Network exception in getSpinOptions: ${e.message}');
      // Try cache as fallback
      final cacheResult = await _getCachedSpinOptions(spinType);
      return cacheResult.fold(
        (failure) => Left(NetworkFailure(message: e.message)),
        (options) => Right(options),
      );
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getSpinOptions',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: 'An unexpected error occurred'));
    }
  }

  Future<Either<Failure, List<SpinOptionEntity>>> _getCachedSpinOptions(
    String spinType,
  ) async {
    try {
      final cachedOptions = await localDataSource.getCachedSpinOptions(
        spinType,
      );
      if (cachedOptions.isNotEmpty) {
        return Right(cachedOptions.map((option) => option.toEntity()).toList());
      } else {
        return const Left(
          CacheFailure(message: 'No cached spin options available'),
        );
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to get cached options'));
    }
  }

  @override
  Future<Either<Failure, SpinResultEntity>> performSpin({
    required String optionId,
    required String spinType,
    bool isUnlimited = false,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await remoteDataSource.performSpin(
          optionId: optionId,
          spinType: spinType,
          isUnlimited: isUnlimited,
        );

        // Cache the result locally
        await localDataSource.cacheSpinResult(result);

        // Update local spin tracking
        if (!isUnlimited) {
          await localDataSource.incrementTodaySpinCount(spinType);
          await localDataSource.setLastSpinDate(spinType, DateTime.now());
        }

        return Right(result.toEntity());
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } on ServerException catch (e) {
      dev.log('Server exception in performSpin: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in performSpin: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in performSpin',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<SpinHistoryEntity>>> getSpinHistory({
    int page = 1,
    int limit = 10,
    String? spinType,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final history = await remoteDataSource.getSpinHistory(
            page: page,
            limit: limit,
            spinType: spinType,
          );

          return Right(history.map((item) => item.toEntity()).toList());
        } catch (e) {
          // If remote fails and it's first page, try cache
          if (page == 1) {
            return await _getCachedSpinHistory();
          }
          rethrow;
        }
      } else {
        // No internet, use cache
        if (page == 1) {
          return await _getCachedSpinHistory();
        } else {
          return const Left(NetworkFailure(message: 'No internet connection'));
        }
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getSpinHistory: ${e.message}');
      if (page == 1) {
        final cacheResult = await _getCachedSpinHistory();
        return cacheResult.fold(
          (failure) => Left(ServerFailure(message: e.message)),
          (history) => Right(history),
        );
      }
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getSpinHistory: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getSpinHistory',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: 'An unexpected error occurred'));
    }
  }

  Future<Either<Failure, List<SpinHistoryEntity>>>
  _getCachedSpinHistory() async {
    try {
      final cachedResults = await localDataSource.getCachedSpinResults();
      if (cachedResults.isNotEmpty) {
        // Group results by date to create history entities
        final groupedResults = <String, List<SpinResultModel>>{};
        for (final result in cachedResults) {
          final dateKey =
              '${result.timestamp.year}-${result.timestamp.month}-${result.timestamp.day}';
          groupedResults.putIfAbsent(dateKey, () => []).add(result);
        }

        final historyEntities = groupedResults.entries.map((entry) {
          final results = entry.value;
          final date = results.first.timestamp;
          final winningSpins = results
              .where((r) => r.isSuccess && r.spinOption.isWinningOption)
              .length;
          final loyaltyPointsEarned = results
              .where((r) => r.spinOption.loyaltyPoints != null)
              .fold<int>(
                0,
                (sum, r) => sum + (r.spinOption.loyaltyPoints ?? 0),
              );
          final couponsEarned = results
              .where((r) => r.spinOption.couponCode != null)
              .map((r) => r.spinOption.couponCode!)
              .toList();

          return SpinHistoryEntity(
            id: entry.key,
            results: results.map((r) => r.toEntity()).toList(),
            date: date,
            totalSpins: results.length,
            winningSpins: winningSpins,
            loyaltyPointsEarned: loyaltyPointsEarned,
            couponsEarned: couponsEarned,
          );
        }).toList();

        return Right(historyEntities);
      } else {
        return const Left(
          CacheFailure(message: 'No cached spin history available'),
        );
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to get cached history'));
    }
  }

  @override
  Future<Either<Failure, bool>> canUserSpin(String spinType) async {
    try {
      if (await networkInfo.isConnected) {
        final canSpin = await remoteDataSource.canUserSpin(spinType);
        return Right(canSpin);
      } else {
        // For offline mode, check local tracking
        final todaySpinCount = await localDataSource.getTodaySpinCount(
          spinType,
        );
        final maxSpins = spinType == 'daily_spin'
            ? 1
            : 999; // Assume unlimited for spin_and_win
        return Right(todaySpinCount < maxSpins);
      }
    } on ServerException catch (e) {
      dev.log('Server exception in canUserSpin: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in canUserSpin: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in canUserSpin',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, int>> getRemainingSpins(String spinType) async {
    try {
      if (await networkInfo.isConnected) {
        final remainingSpins = await remoteDataSource.getRemainingSpins(
          spinType,
        );
        return Right(remainingSpins);
      } else {
        // For offline mode, calculate from local tracking
        final todaySpinCount = await localDataSource.getTodaySpinCount(
          spinType,
        );
        final maxSpins = spinType == 'daily_spin'
            ? 1
            : 999; // Assume unlimited for spin_and_win
        final remaining = maxSpins - todaySpinCount;
        return Right(remaining > 0 ? remaining : 0);
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getRemainingSpins: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getRemainingSpins: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getRemainingSpins',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, int>> getUserLoyaltyPoints() async {
    try {
      if (await networkInfo.isConnected) {
        final loyaltyPoints = await remoteDataSource.getUserLoyaltyPoints();
        return Right(loyaltyPoints);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getUserLoyaltyPoints: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getUserLoyaltyPoints: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getUserLoyaltyPoints',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to clear cache'));
    }
  }

  @override
  Future<Either<Failure, List<SpinOptionEntity>>> getCachedSpinOptions(
    String spinType,
  ) async {
    return await _getCachedSpinOptions(spinType);
  }

  @override
  Future<Either<Failure, void>> cacheSpinOptions(
    String spinType,
    List<SpinOptionEntity> options,
  ) async {
    try {
      final optionModels = options
          .map((option) => SpinOptionModel.fromEntity(option))
          .toList();
      await localDataSource.cacheSpinOptions(spinType, optionModels);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to cache spin options'));
    }
  }
}
