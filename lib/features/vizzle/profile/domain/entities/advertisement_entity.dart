import 'package:equatable/equatable.dart';

class AdvertisementEntity extends Equatable {
  final String id;
  final String userId;
  final String district;
  final String title;
  final String description;
  final String shareLink;
  final List<String> images;
  final String category;
  final String subCategory;
  final String latitude;
  final String longitude;
  final String address;
  final int? year;
  final String age;
  final int? kilometers;
  final double? price;
  final String phone;
  final String fuelType;
  final String color;
  final String transmissionType;
  final String usage;
  final String condition;
  final dynamic engineCapacity;
  final String sellerType;
  final dynamic warrenty;
  final String brand;
  final String memory;
  final String processor;
  final String hardDrive;
  final String type;
  final String duration;
  final String rating;
  final String model;
  final String damage;
  final List<String> damageDetails;
  final List<String> materials;
  final String batteryPercentage;
  final String version;
  final List<String> accompaniments;
  final bool? carrierLock;
  final String imeiNumber;
  final dynamic number;
  final String storageCapacity;
  final String memoryRam;
  final List<String> insights;
  final List<dynamic> membersSaved;
  final List<String> membersShared;
  final List<dynamic> reports;
  final bool isRemoved;
  final bool isDeleted;
  final bool isSold;
  final DateTime? renewDate;
  final bool renewed;
  final bool isApproved;
  final String approvalStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? rejectionReason;

  const AdvertisementEntity({
    required this.id,
    required this.userId,
    required this.district,
    required this.title,
    required this.description,
    required this.shareLink,
    required this.images,
    required this.category,
    required this.subCategory,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.year,
    required this.age,
    this.kilometers,
    this.price,
    required this.phone,
    required this.fuelType,
    required this.color,
    required this.transmissionType,
    required this.usage,
    required this.condition,
    this.engineCapacity,
    required this.sellerType,
    this.warrenty,
    required this.brand,
    required this.memory,
    required this.processor,
    required this.hardDrive,
    required this.type,
    required this.duration,
    required this.rating,
    required this.model,
    required this.damage,
    required this.damageDetails,
    required this.materials,
    required this.batteryPercentage,
    required this.version,
    required this.accompaniments,
    this.carrierLock,
    required this.imeiNumber,
    this.number,
    required this.storageCapacity,
    required this.memoryRam,
    required this.insights,
    required this.membersSaved,
    required this.membersShared,
    required this.reports,
    required this.isRemoved,
    required this.isDeleted,
    required this.isSold,
    this.renewDate,
    required this.renewed,
    required this.isApproved,
    required this.approvalStatus,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.rejectionReason,
  });

  String get primaryImage => images.isNotEmpty ? images.first : '';

  String get formattedPrice {
    if (price == null) return 'Price not available';
    return 'RS ${price!.toStringAsFixed(2)}';
  }

  String get statusDisplay {
    if (isSold) return 'Sold';
    if (isApproved) return 'Active';
    if (approvalStatus.toLowerCase().contains('rejected')) return 'Rejected';
    if (approvalStatus.toLowerCase().contains('pending')) return 'Pending';
    return 'Unknown';
  }

  bool get isRejected => approvalStatus.toLowerCase().contains('rejected');
  bool get isPending => approvalStatus.toLowerCase().contains('pending');
  bool get isActive => isApproved && !isSold;

  String get brandModel {
    final parts = <String>[];
    if (brand.isNotEmpty) parts.add(brand);
    if (model.isNotEmpty) parts.add(model);
    return parts.join(' ');
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    district,
    title,
    description,
    shareLink,
    images,
    category,
    subCategory,
    latitude,
    longitude,
    address,
    year,
    age,
    kilometers,
    price,
    phone,
    fuelType,
    color,
    transmissionType,
    usage,
    condition,
    engineCapacity,
    sellerType,
    warrenty,
    brand,
    memory,
    processor,
    hardDrive,
    type,
    duration,
    rating,
    model,
    damage,
    damageDetails,
    materials,
    batteryPercentage,
    version,
    accompaniments,
    carrierLock,
    imeiNumber,
    number,
    storageCapacity,
    memoryRam,
    insights,
    membersSaved,
    membersShared,
    reports,
    isRemoved,
    isDeleted,
    isSold,
    renewDate,
    renewed,
    isApproved,
    approvalStatus,
    createdAt,
    updatedAt,
    v,
    rejectionReason,
  ];
}
