import 'package:equatable/equatable.dart';

class CouponData extends Equatable {
  final String id;
  final String couponName;
  final double minimumPrice;
  final String description;
  final int useCountPerUser;
  final int maximumUsers;
  final double discount;
  final String discountType;
  final DateTime startDate;
  final DateTime endDate;
  final bool isShowInUser;
  final String createdBy;
  final String vendorId;
  final int totalUsageCount;
  final List<dynamic> usedUsers;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CouponData({
    required this.id,
    required this.couponName,
    required this.minimumPrice,
    required this.description,
    required this.useCountPerUser,
    required this.maximumUsers,
    required this.discount,
    required this.discountType,
    required this.startDate,
    required this.endDate,
    required this.isShowInUser,
    required this.createdBy,
    required this.vendorId,
    required this.totalUsageCount,
    required this.usedUsers,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPercentageDiscount => discountType.toLowerCase() == 'percentage';
  bool get isAmountDiscount => discountType.toLowerCase() == 'amount';
  bool get isActive =>
      DateTime.now().isAfter(startDate) && DateTime.now().isBefore(endDate);
  int get remainingUses => maximumUsers - totalUsageCount;

  String get displayDiscount {
    if (isPercentageDiscount) {
      return '${discount.toInt()}%';
    } else {
      return 'RS.${discount.toStringAsFixed(2)}';
    }
  }

  @override
  List<Object?> get props => [
    id,
    couponName,
    minimumPrice,
    description,
    useCountPerUser,
    maximumUsers,
    discount,
    discountType,
    startDate,
    endDate,
    isShowInUser,
    createdBy,
    vendorId,
    totalUsageCount,
    usedUsers,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}
