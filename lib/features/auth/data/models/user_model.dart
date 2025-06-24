import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.profileImage,
    super.gender,
    super.dateOfBirth,
    super.profession,
    super.country,
    super.state,
    super.district,
    super.tier,
    super.loyaltyPoints,
    super.walletAmount,
    super.isOtpVerified,
    super.profileCompleted,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'],
      gender: json['gender'],
      dateOfBirth: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
      profession: json['occupation'],
      country: json['country'],
      state: json['state'],
      district: json['district'],
      tier: json['tier'],
      loyaltyPoints: json['loyalityPoints'] ?? 0,
      walletAmount: (json['walletAmount'] ?? 0).toDouble(),
      isOtpVerified: json['isOtpVerified'] ?? false,
      profileCompleted: json['profileCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'gender': gender,
      'dob': dateOfBirth?.toIso8601String(),
      'occupation': profession,
      'country': country,
      'state': state,
      'district': district,
      'tier': tier,
      'loyalityPoints': loyaltyPoints,
      'walletAmount': walletAmount,
      'isOtpVerified': isOtpVerified,
      'profileCompleted': profileCompleted,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? gender,
    DateTime? dateOfBirth,
    String? profession,
    String? country,
    String? state,
    String? district,
    String? tier,
    int? loyaltyPoints,
    double? walletAmount,
    bool? isOtpVerified,
    bool? profileCompleted,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profession: profession ?? this.profession,
      country: country ?? this.country,
      state: state ?? this.state,
      district: district ?? this.district,
      tier: tier ?? this.tier,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      walletAmount: walletAmount ?? this.walletAmount,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      profileCompleted: profileCompleted ?? this.profileCompleted,
    );
  }
}
