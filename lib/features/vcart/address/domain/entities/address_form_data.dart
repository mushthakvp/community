import 'package:equatable/equatable.dart';

import 'address.dart';

class AddressFormData extends Equatable {
  final String title;
  final String name;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String pinCode;

  const AddressFormData({
    required this.title,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.pinCode,
  });

  bool get isValid =>
      title.isNotEmpty &&
      name.isNotEmpty &&
      phone.isNotEmpty &&
      address.isNotEmpty &&
      city.isNotEmpty &&
      state.isNotEmpty &&
      pinCode.isNotEmpty;

  Address toAddress({String? id}) {
    return Address(
      id: id,
      title: title,
      name: name,
      phone: phone,
      address: address,
      city: city,
      state: state,
      pinCode: pinCode,
    );
  }

  @override
  List<Object?> get props => [
    title,
    name,
    phone,
    address,
    city,
    state,
    pinCode,
  ];

  AddressFormData copyWith({
    String? title,
    String? name,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? pinCode,
  }) {
    return AddressFormData(
      title: title ?? this.title,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
    );
  }
}
