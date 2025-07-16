import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/promos_data.dart';

abstract class PromosRepository {
  Future<Either<Failure, PromosData>> getPromos();
  Future<Either<Failure, bool>> addRewardPoints({
    required int points,
    required String action,
  });
}
