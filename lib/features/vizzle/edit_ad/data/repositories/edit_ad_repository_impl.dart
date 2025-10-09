import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../../profile/domain/entities/advertisement_entity.dart';
import '../../domain/entities/edit_ad_request_entity.dart';
import '../../domain/entities/edit_ad_response_entity.dart';
import '../../domain/repositories/edit_ad_repository.dart';
import '../datasources/edit_ad_remote_datasource.dart';
import '../models/edit_ad_request_model.dart';

class EditAdRepositoryImpl implements EditAdRepository {
  final EditAdRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  EditAdRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AdvertisementEntity>> getAdDetails(String adId) async {
    try {
      final remoteAd = await remoteDataSource.getAdDetails(adId);
      return Right(remoteAd);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EditAdResponseEntity>> editAd(
    EditAdRequestEntity request,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final requestModel = EditAdRequestModel.fromEntity(request);
        final response = await remoteDataSource.editAd(requestModel);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadImages(
    List<String> imagePaths,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final uploadedUrls = await remoteDataSource.uploadImages(imagePaths);
        return Right(uploadedUrls);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
