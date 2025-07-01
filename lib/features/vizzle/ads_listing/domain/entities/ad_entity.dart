import 'package:equatable/equatable.dart';

class AdEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String shareLink;
  final List<String> images;
  final double price;
  final String currency;
  final String location;
  final String category;
  final String subCategory;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFeatured;
  final bool isActive;
  final bool isSaved;
  final AdContactInfo contactInfo;
  final AdVehicleInfo? vehicleInfo;
  final AdPropertyInfo? propertyInfo;

  const AdEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.shareLink,
    required this.images,
    required this.price,
    required this.currency,
    required this.location,
    required this.category,
    required this.subCategory,
    required this.createdAt,
    required this.updatedAt,
    required this.isFeatured,
    required this.isActive,
    required this.isSaved,
    required this.contactInfo,
    this.vehicleInfo,
    this.propertyInfo,
  });

  AdEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? shareLink,
    List<String>? images,
    double? price,
    String? currency,
    String? location,
    String? category,
    String? subCategory,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFeatured,
    bool? isActive,
    bool? isSaved,
    AdContactInfo? contactInfo,
    AdVehicleInfo? vehicleInfo,
    AdPropertyInfo? propertyInfo,
  }) {
    return AdEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      shareLink: shareLink ?? this.shareLink,
      images: images ?? this.images,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      location: location ?? this.location,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFeatured: isFeatured ?? this.isFeatured,
      isActive: isActive ?? this.isActive,
      isSaved: isSaved ?? this.isSaved,
      contactInfo: contactInfo ?? this.contactInfo,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      propertyInfo: propertyInfo ?? this.propertyInfo,
    );
  }

  // Helper getters
  String get displayTitle => title.isNotEmpty ? title : 'Untitled';
  String get formattedPrice => '$currency ${price.toStringAsFixed(2)}';
  String get primaryImage => images.isNotEmpty ? images.first : '';
  bool get hasImages => images.isNotEmpty;
  bool get isMotorAd => vehicleInfo != null;
  bool get isPropertyAd => propertyInfo != null;
  String get timeAgo => _formatTimeAgo(DateTime.now().difference(createdAt));

  String _formatTimeAgo(Duration difference) {
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    shareLink,
    images,
    price,
    currency,
    location,
    category,
    subCategory,
    createdAt,
    updatedAt,
    isFeatured,
    isActive,
    isSaved,
    contactInfo,
    vehicleInfo,
    propertyInfo,
  ];
}

class AdContactInfo extends Equatable {
  final String sellerName;
  final String phoneNumber;
  final String email;
  final bool isVerified;

  const AdContactInfo({
    required this.sellerName,
    required this.phoneNumber,
    required this.email,
    required this.isVerified,
  });

  @override
  List<Object?> get props => [sellerName, phoneNumber, email, isVerified];
}

class AdVehicleInfo extends Equatable {
  final String brand;
  final String model;
  final int year;
  final int kilometers;
  final String fuelType;
  final String transmission;
  final String color;
  final String engineCapacity;

  const AdVehicleInfo({
    required this.brand,
    required this.model,
    required this.year,
    required this.kilometers,
    required this.fuelType,
    required this.transmission,
    required this.color,
    required this.engineCapacity,
  });

  String get displayInfo => '$year • $kilometers km • $fuelType';

  @override
  List<Object?> get props => [
    brand,
    model,
    year,
    kilometers,
    fuelType,
    transmission,
    color,
    engineCapacity,
  ];
}

class AdPropertyInfo extends Equatable {
  final String propertyType;
  final int bedrooms;
  final int bathrooms;
  final double area;
  final String areaUnit;
  final List<String> amenities;

  const AdPropertyInfo({
    required this.propertyType,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.areaUnit,
    required this.amenities,
  });

  String get displayInfo => '$bedrooms bed • $bathrooms bath • $area $areaUnit';

  @override
  List<Object?> get props => [
    propertyType,
    bedrooms,
    bathrooms,
    area,
    areaUnit,
    amenities,
  ];
}
