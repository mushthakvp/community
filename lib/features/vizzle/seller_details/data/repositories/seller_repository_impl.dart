import 'package:dartz/dartz.dart';

import '../../../../../core/error/error_handler.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/seller_profile.dart';
import '../../domain/repositories/seller_repository.dart';
import '../datasources/seller_remote_datasource.dart';

class SellerRepositoryImpl implements SellerRepository {
  final SellerRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SellerRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SellerProfile>> getSellerProfile(
    String sellerId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getSellerProfile(sellerId);
        return Right(result);
      } catch (e) {
        return Left(ErrorHandler.handleException(e as Exception));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
