import 'package:equatable/equatable.dart';

import 'advertisement_entity.dart';
import 'user_entity.dart';

class ProfileEntity extends Equatable {
  final bool success;
  final String message;
  final UserEntity? user;
  final int activeAdsCount;
  final int renewAdsCount;
  final int jobsCount;
  final int chatToAnswer;
  final String currencyCode;
  final int adsCount;
  final List<AdvertisementEntity> advertisements;

  const ProfileEntity({
    required this.success,
    required this.message,
    this.user,
    required this.activeAdsCount,
    required this.renewAdsCount,
    required this.jobsCount,
    required this.chatToAnswer,
    required this.currencyCode,
    required this.adsCount,
    required this.advertisements,
  });

  bool get hasAds => advertisements.isNotEmpty;
  int get totalAdsCount => advertisements.length;

  @override
  List<Object?> get props => [
    success,
    message,
    user,
    activeAdsCount,
    renewAdsCount,
    jobsCount,
    chatToAnswer,
    currencyCode,
    adsCount,
    advertisements,
  ];
}
