import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/address_form_data.dart';
import '../../domain/entities/address_list_data.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_local_datasource.dart';
import '../datasources/address_remote_datasource.dart';
import '../models/address_model.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;
  final AddressLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AddressRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AddressListData>> getAddresses({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final response = await remoteDataSource.getAddresses(
          page: page,
          limit: limit,
        );
        return Right(response);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Address>> addAddress(AddressFormData formData) async {
    try {
      if (await networkInfo.isConnected) {
        final addressData = {
          'title': formData.title,
          'name': formData.name,
          'phone': formData.phone,
          'address': formData.address,
          'city': formData.city,
          'state': formData.state,
          'pinCode': formData.pinCode,
        };

        final address = await remoteDataSource.addAddress(addressData);
        return Right(address);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Address>> updateAddress({
    required String id,
    required AddressFormData formData,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final addressData = {
          'title': formData.title,
          'name': formData.name,
          'phone': formData.phone,
          'address': formData.address,
          'city': formData.city,
          'state': formData.state,
          'pinCode': formData.pinCode,
        };

        final address = await remoteDataSource.updateAddress(
          id: id,
          addressData: addressData,
        );
        return Right(address);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAddress(String id) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await remoteDataSource.deleteAddress(id);
        return Right(result);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, Address?>> getCachedSelectedAddress() async {
    try {
      final cachedAddress = await localDataSource.getCachedSelectedAddress();
      return Right(cachedAddress);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> cacheSelectedAddress(Address address) async {
    try {
      final addressModel = AddressModel(
        id: address.id,
        title: address.title,
        name: address.name,
        phone: address.phone,
        address: address.address,
        city: address.city,
        state: address.state,
        pinCode: address.pinCode,
        createdAt: address.createdAt,
        isSelected: address.isSelected,
      );

      await localDataSource.cacheSelectedAddress(addressModel);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> clearAddressCache() async {
    try {
      await localDataSource.clearAddressCache();
      return const Right(null);
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
