import '../../domain/entities/profile_entity.dart';
import 'advertisement_model.dart';
import 'user_model.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.success,
    required super.message,
    super.user,
    required super.activeAdsCount,
    required super.renewAdsCount,
    required super.jobsCount,
    required super.chatToAnswer,
    required super.currencyCode,
    required super.adsCount,
    required super.advertisements,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      activeAdsCount: json['activeAdsCount'] ?? 0,
      renewAdsCount: json['renewAdsCount'] ?? 0,
      jobsCount: json['jobsCount'] ?? 0,
      chatToAnswer: json['chatToAnswer'] ?? 0,
      currencyCode: json['currencyCode'] ?? '',
      adsCount: json['adsCount'] ?? 0,
      advertisements: json['advertisements'] != null
          ? List<AdvertisementModel>.from(
              json['advertisements'].map((x) => AdvertisementModel.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': user != null ? (user as UserModel).toJson() : null,
      'activeAdsCount': activeAdsCount,
      'renewAdsCount': renewAdsCount,
      'jobsCount': jobsCount,
      'chatToAnswer': chatToAnswer,
      'currencyCode': currencyCode,
      'adsCount': adsCount,
      'advertisements': advertisements
          .map((ad) => (ad as AdvertisementModel).toJson())
          .toList(),
    };
  }
}
