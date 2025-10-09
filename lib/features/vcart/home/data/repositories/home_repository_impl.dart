import 'package:dartz/dartz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/home_data.dart';
//import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/home_data_model.dart';
import 'package:livera/features/vcart/home/domain/repositories/home_repository.dart';
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, HomeData>> getHomeData() async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final remoteData = await remoteDataSource.getHomeData();
          await localDataSource.cacheHomeData(remoteData);
          return Right(remoteData);
        } catch (e) {
          // If remote fails, try to get cached data
          final cachedData = await localDataSource.getCachedHomeData();
          if (cachedData != null) {
            return Right(cachedData);
          } else {
            return Left(_handleException(e));
          }
        }
      } else {
        final cachedData = await localDataSource.getCachedHomeData();
        if (cachedData != null) {
          return Right(cachedData);
        } else {
          return const Left(
            NetworkFailure(
              message: 'No internet connection and no cached data available',
            ),
          );
        }
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, String>> getCurrentLocation() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return const Left(
          ValidationFailure(message: 'Location permission denied'),
        );
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final location =
            '${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}';
        return Right(location);
      } else {
        return const Left(
          ValidationFailure(message: 'Unable to get location details'),
        );
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> cacheHomeData(HomeData homeData) async {
    try {
      await localDataSource.cacheHomeData(homeData as HomeDataModel);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, HomeData?>> getCachedHomeData() async {
    try {
      final cachedData = await localDataSource.getCachedHomeData();
      return Right(cachedData);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  Failure _handleException(dynamic exception) {
    if (exception is ServerException) {
      return ServerFailure(message: exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(message: exception.message);
    } else {
      return UnknownFailure(message: exception.toString());
    }
  }
}
