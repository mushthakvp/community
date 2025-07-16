import '../../domain/entities/search_result.dart';

class SearchResultModel extends SearchResult {
  const SearchResultModel({
    required super.success,
    required super.message,
    required super.ads,
    required super.totalAds,
    required super.currencyCode,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      ads:
          (json['ads'] as List<dynamic>?)
              ?.map((ad) => SearchAdModel.fromJson(ad))
              .toList() ??
          [],
      totalAds: json['totalAds'] ?? 0,
      currencyCode: json['currencyCode'] ?? '',
    );
  }
}

class SearchAdModel extends SearchAd {
  const SearchAdModel({
    required super.id,
    required super.title,
    required super.price,
    super.brand,
    required super.images,
    super.shareLink,
  });

  factory SearchAdModel.fromJson(Map<String, dynamic> json) {
    return SearchAdModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      brand: json['brand'],
      images: List<String>.from(json['images'] ?? []),
      shareLink: json['shareLink'],
    );
  }
}
