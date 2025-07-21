import '../../domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel({
    super.id,
    required super.title,
    required super.name,
    required super.phone,
    required super.address,
    required super.city,
    required super.state,
    required super.pinCode,
    super.createdAt,
    super.isSelected,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'] ?? json['id'],
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pinCode: json['pinCode'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'name': name,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'pinCode': pinCode,
      'createdAt': createdAt?.toIso8601String(),
      'isSelected': isSelected,
    };
  }

  @override
  AddressModel copyWith({
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
    return AddressModel(
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
