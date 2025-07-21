import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String? id;
  final String title;
  final String name;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String pinCode;
  final DateTime? createdAt;
  final bool isSelected;

  const Address({
    this.id,
    required this.title,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.pinCode,
    this.createdAt,
    this.isSelected = false,
  });

  String get formattedAddress => '$address, $city, $state, $pinCode';

  String get displayTitle => title.toUpperCase();

  bool get isValid =>
      title.isNotEmpty &&
      name.isNotEmpty &&
      phone.isNotEmpty &&
      address.isNotEmpty &&
      city.isNotEmpty &&
      state.isNotEmpty &&
      pinCode.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    title,
    name,
    phone,
    address,
    city,
    state,
    pinCode,
    createdAt,
    isSelected,
  ];

  Address copyWith({
    String? id,
    String? title,
    String? name,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? pinCode,
    DateTime? createdAt,
    bool? isSelected,
  }) {
    return Address(
      id: id ?? this.id,
      title: title ?? this.title,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
      createdAt: createdAt ?? this.createdAt,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
