import '../../domain/entities/user_details_entity.dart';

class UserDetailsModel extends UserDetailsEntity {
  const UserDetailsModel({
    super.id,
    super.name,
    super.email,
    super.phone,
    super.profileImage,
    super.communityId,
    super.loyaltyPoints,
    super.walletAmount,
    super.currencyCode,
    super.joined,
    super.tier,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      profileImage: json["profileImage"],
      communityId: json["communityId"],
      loyaltyPoints: json["loyaltyPoints"]?.toDouble(),
      walletAmount: json["walletAmount"]?.toDouble(),
      currencyCode: json["currencyCode"],
      joined: json["joined"],
      tier: json["tier"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "profileImage": profileImage,
      "communityId": communityId,
      "loyaltyPoints": loyaltyPoints,
      "walletAmount": walletAmount,
      "currencyCode": currencyCode,
      "joined": joined,
      "tier": tier,
    };
  }

  UserDetailsEntity toEntity() {
    return UserDetailsEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      profileImage: profileImage,
      communityId: communityId,
      loyaltyPoints: loyaltyPoints,
      walletAmount: walletAmount,
      currencyCode: currencyCode,
      joined: joined,
      tier: tier,
    );
  }
}