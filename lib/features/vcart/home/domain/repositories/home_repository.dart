import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/home_data.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeData>> getHomeData();
  Future<Either<Failure, String>> getCurrentLocation();
  Future<Either<Failure, void>> cacheHomeData(HomeData homeData);
  Future<Either<Failure, HomeData?>> getCachedHomeData();
}
