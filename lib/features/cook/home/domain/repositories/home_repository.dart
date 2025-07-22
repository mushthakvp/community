import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/cooking_home.dart';

abstract class HomeRepository {
  Future<Either<Failure, CookingHome>> getCookingHome({
    String? search,
    int currentPage = 1,
    int currentLimit = 3,
    int upcomingPage = 1,
    int upcomingLimit = 10,
  });
}
