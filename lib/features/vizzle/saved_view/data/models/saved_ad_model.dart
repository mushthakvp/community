import '../../domain/entities/saved_ad_entity.dart';

class SavedAdModel extends SavedAdEntity {
  const SavedAdModel({
    required super.id,
    required super.title,
    required super.price,
    required super.currencyCode,
    required super.district,
    required super.brand,
    required super.model,
    required super.images,
    required super.isSaved,
    super.year,
    super.kilometers,
    super.address,
    super.latitude,
    super.longitude,
    super.shareLink,
  });

  factory SavedAdModel.fromJson(Map<String, dynamic> json) {
    return SavedAdModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currencyCode: json['currencyCode'] ?? '',
      district: json['district'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      isSaved: json['isSaved'] ?? false,
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
      'year': year,
      'kilometers': kilometers,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'shareLink': shareLink,
    };
  }

  SavedAdModel copyWith({
    String? id,
    String? title,
    double? price,
    String? currencyCode,
    String? district,
    String? brand,
    String? model,
    List<String>? images,
    bool? isSaved,
    int? year,
    int? kilometers,
    String? address,
    String? latitude,
    String? longitude,
    String? shareLink,
  }) {
    return SavedAdModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      currencyCode: currencyCode ?? this.currencyCode,
      district: district ?? this.district,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      images: images ?? this.images,
      isSaved: isSaved ?? this.isSaved,
      year: year ?? this.year,
      kilometers: kilometers ?? this.kilometers,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      shareLink: shareLink ?? this.shareLink,
    );
  }
}
