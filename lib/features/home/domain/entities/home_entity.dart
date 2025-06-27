import 'package:equatable/equatable.dart';

class UserDetailsEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final String tier;
  final int loyaltyPoints;
  final double walletAmount;
  final String currencyCode;
  final String communityId;
  final List<BannerEntity> banners;
  final String? marquee;
  final String? stateEmail;
  final bool isSpinned;

  const UserDetailsEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.tier,
    required this.loyaltyPoints,
    required this.walletAmount,
    required this.currencyCode,
    required this.communityId,
    required this.banners,
    this.marquee,
    this.stateEmail,
    required this.isSpinned,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    profileImage,
    tier,
    loyaltyPoints,
    walletAmount,
    currencyCode,
    communityId,
    banners,
    marquee,
    stateEmail,
    isSpinned,
  ];
}

class BannerEntity extends Equatable {
  final String id;
  final String image;
  final String type;

  const BannerEntity({
    required this.id,
    required this.image,
    required this.type,
  });

  @override
  List<Object> get props => [id, image, type];
}

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, title, message, createdAt];
}
