import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/filter_data.dart';
import '../../domain/repositories/filter_page_repository.dart';
import '../datasources/filter_page_remote_datasource.dart';

class FilterPageRepositoryImpl implements FilterPageRepository {
  final FilterPageRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FilterPageRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, FilterData>> getFilterData({
    String? sectionId,
    String? brandId,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteData = await remoteDataSource.getFilterData(
          sectionId: sectionId,
          brandId: brandId,
        );
        return Right(remoteData);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  Failure _handleException(dynamic exception) {
    if (exception is ServerException) {
      return ServerFailure(message: exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    } else {
      return UnknownFailure(message: exception.toString());
    }
  }
}
