import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/promos_data.dart';
import '../../domain/repositories/promos_repository.dart';
import '../datasources/promos_remote_datasource.dart';

class PromosRepositoryImpl implements PromosRepository {
  final PromosRemoteDataSource remoteDataSource;

  PromosRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PromosData>> getPromos() async {
    try {
      final result = await remoteDataSource.getPromos();

      final promosData = PromosData(
        videos: result.videos?.map((video) => video.toEntity()).toList() ?? [],
        promos: result.promos?.map((promo) => promo.toEntity()).toList() ?? [],
        socialLinks: result.socialLinks?.toEntity(),
      );

      return Right(promosData);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, bool>> addRewardPoints({
    required int points,
    required String action,
  }) async {
    try {
      final result = await remoteDataSource.addRewardPoints(
        points: points,
        action: action,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to add reward points'));
    }
  }
}
