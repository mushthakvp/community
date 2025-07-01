import '../../domain/entities/recently_viewed_ad_entity.dart';

class RecentlyViewedAdModel extends RecentlyViewedAdEntity {
  const RecentlyViewedAdModel({
    required super.id,
    required super.title,
    required super.price,
    required super.currencyCode,
    required super.district,
    required super.brand,
    required super.model,
    required super.images,
    required super.isSaved,
    required super.viewedAt,
    super.year,
    super.kilometers,
    super.address,
    super.latitude,
    super.longitude,
    super.shareLink,
  });

  factory RecentlyViewedAdModel.fromJson(Map<String, dynamic> json) {
    return RecentlyViewedAdModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currencyCode: json['currencyCode'] ?? '',
      district: json['district'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      isSaved: json['isSaved'] ?? false,
      viewedAt: json['viewedAt'] != null
          ? DateTime.parse(json['viewedAt'])
          : DateTime.now(),
      year: json['year'],
      kilometers: json['kilometers'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      shareLink: json['shareLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'currencyCode': currencyCode,
      'district': district,
      'brand': brand,
      'model': model,
      'images': images,
      'isSaved': isSaved,
      'viewedAt': viewedAt.toIso8601String(),
      'year': year,
      'kilometers': kilometers,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'shareLink': shareLink,
    };
  }
}
