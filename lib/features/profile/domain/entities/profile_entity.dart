import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final String communityId;
  final String tier;
  final int loyaltyPoints;
  final double walletAmount;
  final String currencyCode;
  final DateTime joinedDate;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.communityId,
    required this.tier,
    required this.loyaltyPoints,
    required this.walletAmount,
    required this.currencyCode,
    required this.joinedDate,
  });

  ProfileEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? communityId,
    String? tier,
    int? loyaltyPoints,
    double? walletAmount,
    String? currencyCode,
    DateTime? joinedDate,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      communityId: communityId ?? this.communityId,
      tier: tier ?? this.tier,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      walletAmount: walletAmount ?? this.walletAmount,
      currencyCode: currencyCode ?? this.currencyCode,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }

  @override
  List<Object> get props => [
    id,
    name,
    email,
    phone,
    profileImage,
    communityId,
    tier,
    loyaltyPoints,
    walletAmount,
    currencyCode,
    joinedDate,
  ];

  @override
  String toString() {
    return 'ProfileEntity(id: $id, name: $name, email: $email, phone: $phone, '
        'profileImage: $profileImage, communityId: $communityId, tier: $tier, '
        'loyaltyPoints: $loyaltyPoints, walletAmount: $walletAmount, '
        'currencyCode: $currencyCode, joinedDate: $joinedDate)';
  }
}
