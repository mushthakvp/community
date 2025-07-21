import '../../domain/entities/address.dart';
import '../../domain/entities/address_list_data.dart';
import 'address_model.dart';

class AddressListResponseModel extends AddressListData {
  const AddressListResponseModel({
    required super.addresses,
    super.isLoading,
    super.hasMoreData,
    super.currentPage,
    super.errorMessage,
  });

  factory AddressListResponseModel.fromJson(Map<String, dynamic> json) {
    final addressList =
        (json['shippingAddress'] as List<dynamic>?)
            ?.map((item) => AddressModel.fromJson(item as Map<String, dynamic>))
            .cast<Address>()
            .toList() ??
        [];

    final totalPage = json['totalPage'] ?? 1;
    final currentPage = json['currentPage'] ?? 1;

    return AddressListResponseModel(
      addresses: addressList,
      isLoading: false,
      hasMoreData: currentPage < totalPage,
      currentPage: currentPage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shippingAddress': addresses.map((address) {
        if (address is AddressModel) {
          return address.toJson();
        } else {
          return AddressModel(
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
          ).toJson();
        }
      }).toList(),
      'totalPage': hasMoreData ? currentPage + 1 : currentPage,
      'currentPage': currentPage,
    };
  }
}
