import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/error/error_handler.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/ad_creation.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/city.dart';
import '../../domain/repositories/place_add_repository.dart';
import '../datasources/place_add_remote_datasource.dart';
import '../models/ad_creation_model.dart';

class PlaceAddRepositoryImpl implements PlaceAddRepository {
  final PlaceAddRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PlaceAddRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<City>>> getCities() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCities();
        return Right(result);
      } catch (e) {
        return Left(ErrorHandler.handleException(e as Exception));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCategories();
        return Right(result);
      } catch (e) {
        return Left(ErrorHandler.handleException(e as Exception));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadImages(List<XFile> images) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.uploadImages(images);
        return Right(result);
      } catch (e) {
        return Left(ErrorHandler.handleException(e as Exception));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AdCreationResponse>> createAd(
    AdCreationRequest request,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final requestModel = AdCreationRequestModel(
          title: request.title,
          description: request.description,
          price: request.price,
          phoneNumber: request.phoneNumber,
          district: request.district,
          categoryId: request.categoryId,
          subCategoryId: request.subCategoryId,
          subSubCategoryId: request.subSubCategoryId,
          images: request.images,
          latitude: request.latitude,
          longitude: request.longitude,
          address: request.address,
          additionalFields: request.additionalFields,
        );

        final result = await remoteDataSource.createAd(requestModel);
        return Right(result);
      } catch (e) {
        return Left(ErrorHandler.handleException(e as Exception));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> getPlaceNameFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getPlaceNameFromCoordinates(
          latitude,
          longitude,
        );
        return Right(result);
      } catch (e) {
        return Left(ErrorHandler.handleException(e as Exception));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
