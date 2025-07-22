import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/challenge_details.dart';
import '../../domain/repositories/challenge_details_repository.dart';
import '../datasources/challenge_details_remote_data_source.dart';

class ChallengeDetailsRepositoryImpl implements ChallengeDetailsRepository {
  final ChallengeDetailsRemoteDataSource remoteDataSource;

  ChallengeDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ChallengeDetails>> getChallengeDetails(
    String challengeId,
  ) async {
    try {
      final result = await remoteDataSource.getChallengeDetails(challengeId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> joinChallenge(String challengeId) async {
    try {
      final result = await remoteDataSource.joinChallenge(challengeId);
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
