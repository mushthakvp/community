import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.profileImage,
    required super.communityId,
    required super.tier,
    required super.loyaltyPoints,
    required super.walletAmount,
    required super.currencyCode,
    required super.joinedDate,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'] ?? '',
      communityId: json['communityId'] ?? '',
      tier: json['tier'] ?? '',
      loyaltyPoints: json['loyaltyPoints'] ?? 0,
      walletAmount: (json['walletAmount'] ?? 0.0).toDouble(),
      currencyCode: json['currencyCode'] ?? '',
      joinedDate: DateTime.tryParse(json['joined'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'communityId': communityId,
      'tier': tier,
      'loyaltyPoints': loyaltyPoints,
      'walletAmount': walletAmount,
      'currencyCode': currencyCode,
      'joined': joinedDate.toIso8601String(),
    };
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      profileImage: profileImage,
      communityId: communityId,
      tier: tier,
      loyaltyPoints: loyaltyPoints,
      walletAmount: walletAmount,
      currencyCode: currencyCode,
      joinedDate: joinedDate,
    );
  }
}
