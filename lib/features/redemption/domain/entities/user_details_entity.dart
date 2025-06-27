class UserDetailsEntity {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? profileImage;
  final String? communityId;
  final double? loyaltyPoints;
  final double? walletAmount;
  final String? currencyCode;
  final String? joined;
  final String? tier;

  const UserDetailsEntity({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profileImage,
    this.communityId,
    this.loyaltyPoints,
    this.walletAmount,
    this.currencyCode,
    this.joined,
    this.tier,
  });
}
