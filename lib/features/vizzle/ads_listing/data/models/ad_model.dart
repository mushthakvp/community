import '../../domain/entities/ad_entity.dart';

class AdModel extends AdEntity {
  const AdModel({
    required super.id,
    required super.title,
    required super.description,
    required super.shareLink,
    required super.images,
    required super.price,
    required super.currency,
    required super.location,
    required super.category,
    required super.subCategory,
    required super.createdAt,
    required super.updatedAt,
    required super.isFeatured,
    required super.isActive,
    required super.isSaved,
    required super.contactInfo,
    super.vehicleInfo,
    super.propertyInfo,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      shareLink: json['shareLink'] ?? '',
      images: json['images'] != null
          ? List<String>.from(json['images'].map((x) => x.toString()))
          : [],
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'Rs',
      location: json['location'] ?? json['district'] ?? '',
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      isFeatured: json['isFeatured'] ?? false,
      isActive: json['isActive'] ?? true,
      isSaved: json['isSaved'] ?? false,
      contactInfo: AdContactInfoModel.fromJson(json['contactInfo'] ?? {}),
      vehicleInfo: json['vehicleInfo'] != null
          ? AdVehicleInfoModel.fromJson(json['vehicleInfo'])
          : _createVehicleInfoFromLegacy(json),
      propertyInfo: json['propertyInfo'] != null
          ? AdPropertyInfoModel.fromJson(json['propertyInfo'])
          : null,
    );
  }

  static AdVehicleInfoModel? _createVehicleInfoFromLegacy(
    Map<String, dynamic> json,
  ) {
    // Handle legacy format where vehicle info is at root level
    if (json['year'] != null || json['kilometers'] != null) {
      return AdVehicleInfoModel(
        brand: json['brand']?.toString() ?? '',
        model: json['model']?.toString() ?? '',
        year: json['year'] ?? 0,
        kilometers: json['kilometers'] ?? 0,
        fuelType: json['fuelType'] ?? '',
        transmission: json['transmission'] ?? '',
        color: json['color'] ?? '',
        engineCapacity: json['engineCapacity'] ?? '',
      );
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'shareLink': shareLink,
      'images': images,
      'price': price,
      'currency': currency,
      'location': location,
      'category': category,
      'subCategory': subCategory,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFeatured': isFeatured,
      'isActive': isActive,
      'isSaved': isSaved,
      'contactInfo': (contactInfo as AdContactInfoModel).toJson(),
      if (vehicleInfo != null)
        'vehicleInfo': (vehicleInfo! as AdVehicleInfoModel).toJson(),
      if (propertyInfo != null)
        'propertyInfo': (propertyInfo! as AdPropertyInfoModel).toJson(),
    };
  }
}

class AdContactInfoModel extends AdContactInfo {
  const AdContactInfoModel({
    required super.sellerName,
    required super.phoneNumber,
    required super.email,
    required super.isVerified,
  });

  factory AdContactInfoModel.fromJson(Map<String, dynamic> json) {
    return AdContactInfoModel(
      sellerName: json['sellerName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sellerName': sellerName,
      'phoneNumber': phoneNumber,
      'email': email,
      'isVerified': isVerified,
    };
  }
}

class AdVehicleInfoModel extends AdVehicleInfo {
  const AdVehicleInfoModel({
    required super.brand,
    required super.model,
    required super.year,
    required super.kilometers,
    required super.fuelType,
    required super.transmission,
    required super.color,
    required super.engineCapacity,
  });

  factory AdVehicleInfoModel.fromJson(Map<String, dynamic> json) {
    return AdVehicleInfoModel(
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      kilometers: json['kilometers'] ?? 0,
      fuelType: json['fuelType'] ?? '',
      transmission: json['transmission'] ?? '',
      color: json['color'] ?? '',
      engineCapacity: json['engineCapacity'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'model': model,
      'year': year,
      'kilometers': kilometers,
      'fuelType': fuelType,
      'transmission': transmission,
      'color': color,
      'engineCapacity': engineCapacity,
    };
  }
}

class AdPropertyInfoModel extends AdPropertyInfo {
  const AdPropertyInfoModel({
    required super.propertyType,
    required super.bedrooms,
    required super.bathrooms,
    required super.area,
    required super.areaUnit,
    required super.amenities,
  });

  factory AdPropertyInfoModel.fromJson(Map<String, dynamic> json) {
    return AdPropertyInfoModel(
      propertyType: json['propertyType'] ?? '',
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      area: (json['area'] ?? 0).toDouble(),
      areaUnit: json['areaUnit'] ?? 'sqft',
      amenities: json['amenities'] != null
          ? List<String>.from(json['amenities'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'propertyType': propertyType,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'areaUnit': areaUnit,
      'amenities': amenities,
    };
  }
}
