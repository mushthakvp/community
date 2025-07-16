import '../../domain/entities/ads_response_entity.dart';
import 'ad_model.dart';

class AdsResponseModel extends AdsResponseEntity {
  const AdsResponseModel({
    required super.ads,
    required super.totalCount,
    required super.currentPage,
    required super.totalPages,
    required super.hasNextPage,
    required super.hasPreviousPage,
  });

  factory AdsResponseModel.fromJson(Map<String, dynamic> json) {
    final adsData = json['ads'] ?? json['data'] ?? [];
    final List<AdModel> ads = (adsData as List)
        .map((adJson) => AdModel.fromJson(adJson))
        .toList();

    final currentPage = json['currentPage'] ?? json['page'] ?? 1;
    final totalCount = json['totalCount'] ?? json['total'] ?? ads.length;
    final totalPages =
        json['totalPages'] ?? ((totalCount / (json['limit'] ?? 20)).ceil());

    return AdsResponseModel(
      ads: ads,
      totalCount: totalCount,
      currentPage: currentPage,
      totalPages: totalPages,
      hasNextPage: currentPage < totalPages,
      hasPreviousPage: currentPage > 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ads': ads.map((ad) => (ad as AdModel).toJson()).toList(),
      'totalCount': totalCount,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }
}
