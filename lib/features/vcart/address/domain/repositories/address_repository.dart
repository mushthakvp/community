import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/address.dart';
import '../entities/address_form_data.dart';
import '../entities/address_list_data.dart';

abstract class AddressRepository {
  Future<Either<Failure, AddressListData>> getAddresses({
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, Address>> addAddress(AddressFormData formData);

  Future<Either<Failure, Address>> updateAddress({
    required String id,
    required AddressFormData formData,
  });

  Future<Either<Failure, bool>> deleteAddress(String id);

  Future<Either<Failure, Address?>> getCachedSelectedAddress();

  Future<Either<Failure, void>> cacheSelectedAddress(Address address);

  Future<Either<Failure, void>> clearAddressCache();
}
