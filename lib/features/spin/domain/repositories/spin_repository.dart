import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/spin_data_entity.dart';
import '../entities/spin_history_entity.dart';
import '../entities/spin_result_entity.dart';

abstract class SpinRepository {
  /// Get spin options and user data for specified spin type
  Future<Either<Failure, SpinDataEntity>> getSpinData(String spinType);

  /// Execute a spin with the selected option
  Future<Either<Failure, SpinResultEntity>> executeSpin(String optionId);

  /// Get user's spin history with pagination
  Future<Either<Failure, List<SpinHistoryEntity>>> getSpinHistory({
    int page = 1,
    int limit = 10,
  });
}
