import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/prize_overview.dart';

abstract class PrizeOverviewRepository {
  Future<Either<Failure, PrizeOverview>> getPrizeOverview(String challengeId);
}
