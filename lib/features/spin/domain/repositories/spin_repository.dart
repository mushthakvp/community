import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/spin_config_entity.dart';
import '../entities/spin_history_entity.dart';
import '../entities/spin_option_entity.dart';
import '../entities/spin_result_entity.dart';

abstract class SpinRepository {
  // Get spin configuration and options
  Future<Either<Failure, SpinConfigEntity>> getSpinConfig(String spinType);

  // Get available spin options
  Future<Either<Failure, List<SpinOptionEntity>>> getSpinOptions(
    String spinType,
  );

  // Perform a spin
  Future<Either<Failure, SpinResultEntity>> performSpin({
    required String optionId,
    required String spinType,
    bool isUnlimited = false,
  });

  // Get user's spin history
  Future<Either<Failure, List<SpinHistoryEntity>>> getSpinHistory({
    int page = 1,
    int limit = 10,
    String? spinType,
  });

  // Check if user can spin (daily limit, points requirement)
  Future<Either<Failure, bool>> canUserSpin(String spinType);

  // Get user's remaining spins for the day
  Future<Either<Failure, int>> getRemainingSpins(String spinType);

  // Get user's current loyalty points
  Future<Either<Failure, int>> getUserLoyaltyPoints();

  // Cache management
  Future<Either<Failure, void>> clearCache();

  // Offline support
  Future<Either<Failure, List<SpinOptionEntity>>> getCachedSpinOptions(
    String spinType,
  );
  Future<Either<Failure, void>> cacheSpinOptions(
    String spinType,
    List<SpinOptionEntity> options,
  );
}
