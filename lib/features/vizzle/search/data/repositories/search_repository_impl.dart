import 'package:dartz/dartz.dart';

import '../../../../../core/error/error_handler.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SearchResult>> searchAds(String keyword) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.searchAds(keyword);
        return Right(result);
      } catch (e) {
        return Left(ErrorHandler.handleException(e as Exception));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
