import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/prize_overview.dart';
import '../../domain/repositories/prize_overview_repository.dart';
import '../datasources/prize_overview_remote_data_source.dart';

class PrizeOverviewRepositoryImpl implements PrizeOverviewRepository {
  final PrizeOverviewRemoteDataSource remoteDataSource;

  PrizeOverviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PrizeOverview>> getPrizeOverview(
    String challengeId,
  ) async {
    try {
      final result = await remoteDataSource.getPrizeOverview(challengeId);
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
