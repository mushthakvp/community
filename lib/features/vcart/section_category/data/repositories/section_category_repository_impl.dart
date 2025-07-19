import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/section_category_data.dart';
import '../../domain/repositories/section_category_repository.dart';
import '../datasources/section_category_remote_datasource.dart';

class SectionCategoryRepositoryImpl implements SectionCategoryRepository {
  final SectionCategoryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SectionCategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SectionCategoryData>> getCategoriesBySection({
    required String sectionId,
    int page = 1,
    int limit = 1000,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteData = await remoteDataSource.getCategoriesBySection(
          sectionId: sectionId,
          page: page,
          limit: limit,
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
