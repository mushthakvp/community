import 'package:equatable/equatable.dart';

class LoyaltyCardEntity extends Equatable {
  final String name;
  final int loyaltyPoints;
  final String profileImage;
  final double walletAmount;
  final DateTime joinedDate;
  final String communityId;
  final String tier;
  final String currencyCode;

  const LoyaltyCardEntity({
    required this.name,
    required this.loyaltyPoints,
    required this.profileImage,
    required this.walletAmount,
    required this.joinedDate,
    required this.communityId,
    required this.tier,
    required this.currencyCode,
  });

  @override
  List<Object> get props => [
    name,
    loyaltyPoints,
    profileImage,
    walletAmount,
    joinedDate,
    communityId,
    tier,
    currencyCode,
  ];

  @override
  String toString() {
    return 'LoyaltyCardEntity(name: $name, loyaltyPoints: $loyaltyPoints, '
        'profileImage: $profileImage, walletAmount: $walletAmount, '
        'joinedDate: $joinedDate, communityId: $communityId, tier: $tier, '
        'currencyCode: $currencyCode)';
  }
}
