import '../../domain/entities/coupon_data.dart';

class CouponDataModel extends CouponData {
  const CouponDataModel({
    required super.id,
    required super.couponName,
    required super.minimumPrice,
    required super.description,
    required super.useCountPerUser,
    required super.maximumUsers,
    required super.discount,
    required super.discountType,
    required super.startDate,
    required super.endDate,
    required super.isShowInUser,
    required super.createdBy,
    required super.vendorId,
    required super.totalUsageCount,
    required super.usedUsers,
    required super.isDeleted,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CouponDataModel.fromJson(Map<String, dynamic> json) {
    return CouponDataModel(
      id: json['_id'] ?? '',
      couponName: json['couponName'] ?? '',
      minimumPrice: (json['minimumPrice'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      useCountPerUser: json['useCountPerUser'] ?? 0,
      maximumUsers: json['maximumUsers'] ?? 0,
      discount: (json['discount'] ?? 0).toDouble(),
      discountType: json['discountType'] ?? '',
      startDate: DateTime.parse(
        json['startDate'] ?? DateTime.now().toIso8601String(),
      ),
      endDate: DateTime.parse(
        json['endDate'] ?? DateTime.now().toIso8601String(),
      ),
      isShowInUser: json['isShowInUser'] ?? false,
      createdBy: json['createdBy'] ?? '',
      vendorId: json['vendorId'] ?? '',
      totalUsageCount: json['totalUsageCount'] ?? 0,
      usedUsers: List<dynamic>.from(json['usedUsers'] ?? []),
      isDeleted: json['isDeleted'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'couponName': couponName,
      'minimumPrice': minimumPrice,
      'description': description,
      'useCountPerUser': useCountPerUser,
      'maximumUsers': maximumUsers,
      'discount': discount,
      'discountType': discountType,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isShowInUser': isShowInUser,
      'createdBy': createdBy,
      'vendorId': vendorId,
      'totalUsageCount': totalUsageCount,
      'usedUsers': usedUsers,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
