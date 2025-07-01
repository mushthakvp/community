import '../../domain/entities/seller_profile.dart';

class SellerProfileModel extends SellerProfile {
  const SellerProfileModel({
    required super.id,
    required super.name,
    super.profileImage,
    required super.joinedDate,
    required super.advertisements,
  });

  factory SellerProfileModel.fromJson(Map<String, dynamic> json) {
    return SellerProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
      joinedDate: DateTime.tryParse(json['joinedDate'] ?? '') ?? DateTime.now(),
      advertisements:
          (json['advertisements'] as List<dynamic>?)
              ?.map((ad) => AdvertisementModel.fromJson(ad))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImage': profileImage,
      'joinedDate': joinedDate.toIso8601String(),
      'advertisements': advertisements
          .map((ad) => (ad as AdvertisementModel).toJson())
          .toList(),
    };
  }
}

class AdvertisementModel extends Advertisement {
  const AdvertisementModel({
    required super.id,
    required super.title,
    required super.price,
    super.brand,
    super.year,
    required super.images,
    required super.location,
  });

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AdvertisementModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      brand: json['brand'],
      year: json['year'],
      images: List<String>.from(json['images'] ?? []),
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'brand': brand,
      'year': year,
      'images': images,
      'location': location,
    };
  }
}
