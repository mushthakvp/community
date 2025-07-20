import 'package:equatable/equatable.dart';

class Coupon extends Equatable {
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
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Coupon({
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
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPercentageDiscount => discountType.toLowerCase() == 'percentage';
  bool get isAmountDiscount => discountType.toLowerCase() == 'amount';
  bool get isActive =>
      DateTime.now().isAfter(startDate) && DateTime.now().isBefore(endDate);
  int get remainingUsers => maximumUsers - totalUsageCount;
  bool get hasRemainingUses => remainingUsers > 0;

  String get displayDiscount {
    if (isPercentageDiscount) {
      return '${discount.toInt()}%';
    } else {
      return 'RS.${discount.toStringAsFixed(0)}';
    }
  }

  String get validityText {
    final now = DateTime.now();
    if (now.isBefore(startDate)) {
      return 'Valid from ${_formatDate(startDate)}';
    } else if (now.isAfter(endDate)) {
      return 'Expired on ${_formatDate(endDate)}';
    } else {
      return 'Valid until ${_formatDate(endDate)}';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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
    isDeleted,
    createdAt,
    updatedAt,
  ];
}
