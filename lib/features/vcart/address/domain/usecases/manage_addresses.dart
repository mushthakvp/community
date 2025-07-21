import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/address.dart';
import '../entities/address_form_data.dart';
import '../entities/address_list_data.dart';
import '../repositories/address_repository.dart';

class GetAddresses implements UseCase<AddressListData, GetAddressesParams> {
  final AddressRepository repository;

  GetAddresses(this.repository);

  @override
  Future<Either<Failure, AddressListData>> call(
    GetAddressesParams params,
  ) async {
    return await repository.getAddresses(
      page: params.page,
      limit: params.limit,
    );
  }
}

class AddAddress implements UseCase<Address, AddAddressParams> {
  final AddressRepository repository;

  AddAddress(this.repository);

  @override
  Future<Either<Failure, Address>> call(AddAddressParams params) async {
    return await repository.addAddress(params.formData);
  }
}

class UpdateAddress implements UseCase<Address, UpdateAddressParams> {
  final AddressRepository repository;

  UpdateAddress(this.repository);

  @override
  Future<Either<Failure, Address>> call(UpdateAddressParams params) async {
    return await repository.updateAddress(
      id: params.id,
      formData: params.formData,
    );
  }
}

class DeleteAddress implements UseCase<bool, DeleteAddressParams> {
  final AddressRepository repository;

  DeleteAddress(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteAddressParams params) async {
    return await repository.deleteAddress(params.id);
  }
}

class GetCachedSelectedAddress implements UseCase<Address?, NoParams> {
  final AddressRepository repository;

  GetCachedSelectedAddress(this.repository);

  @override
  Future<Either<Failure, Address?>> call(NoParams params) async {
    return await repository.getCachedSelectedAddress();
  }
}

class CacheSelectedAddress
    implements UseCase<void, CacheSelectedAddressParams> {
  final AddressRepository repository;

  CacheSelectedAddress(this.repository);

  @override
  Future<Either<Failure, void>> call(CacheSelectedAddressParams params) async {
    return await repository.cacheSelectedAddress(params.address);
  }
}

// Parameters
class GetAddressesParams {
  final int page;
  final int limit;

  const GetAddressesParams({this.page = 1, this.limit = 10});
}

class AddAddressParams {
  final AddressFormData formData;

  const AddAddressParams({required this.formData});
}

class UpdateAddressParams {
  final String id;
  final AddressFormData formData;

  const UpdateAddressParams({required this.id, required this.formData});
}

class DeleteAddressParams {
  final String id;

  const DeleteAddressParams({required this.id});
}

class CacheSelectedAddressParams {
  final Address address;

  const CacheSelectedAddressParams({required this.address});
}
