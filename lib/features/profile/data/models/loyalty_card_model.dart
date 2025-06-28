import '../../domain/entities/loyalty_card_entity.dart';

class LoyaltyCardModel extends LoyaltyCardEntity {
  const LoyaltyCardModel({
    required super.name,
    required super.loyaltyPoints,
    required super.profileImage,
    required super.walletAmount,
    required super.joinedDate,
    required super.communityId,
    required super.tier,
    required super.currencyCode,
  });

  factory LoyaltyCardModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyCardModel(
      name: json['name'] ?? '',
      loyaltyPoints: json['loyalityPoints'] ?? 0,
      profileImage: json['profileImage'] ?? '',
      walletAmount: (json['walletAmount'] ?? 0.0).toDouble(),
      joinedDate: DateTime.tryParse(json['joined'] ?? '') ?? DateTime.now(),
      communityId: json['communityId'] ?? '',
      tier: json['tier'] ?? '',
      currencyCode: json['currencyCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'loyalityPoints': loyaltyPoints,
      'profileImage': profileImage,
      'walletAmount': walletAmount,
      'joined': joinedDate.toIso8601String(),
      'communityId': communityId,
      'tier': tier,
      'currencyCode': currencyCode,
    };
  }

  LoyaltyCardEntity toEntity() {
    return LoyaltyCardEntity(
      name: name,
      loyaltyPoints: loyaltyPoints,
      profileImage: profileImage,
      walletAmount: walletAmount,
      joinedDate: joinedDate,
      communityId: communityId,
      tier: tier,
      currencyCode: currencyCode,
    );
  }
}
