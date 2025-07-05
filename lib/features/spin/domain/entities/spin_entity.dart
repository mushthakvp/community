import 'package:equatable/equatable.dart';

class SpinEntity extends Equatable {
  final String id;
  final String type;
  final String title;
  final bool isBetterLuck;
  final bool isSpinAgain;
  final String? image;
  final String? couponCode;
  final int? loyaltyPoint;

  const SpinEntity({
    required this.id,
    required this.type,
    required this.title,
    this.isBetterLuck = false,
    this.isSpinAgain = false,
    this.image,
    this.couponCode,
    this.loyaltyPoint,
  });

  SpinEntity copyWith({
    String? id,
    String? type,
    String? title,
    bool? isBetterLuck,
    bool? isSpinAgain,
    String? image,
    String? couponCode,
    int? loyaltyPoint,
  }) {
    return SpinEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      isBetterLuck: isBetterLuck ?? this.isBetterLuck,
      isSpinAgain: isSpinAgain ?? this.isSpinAgain,
      image: image ?? this.image,
      couponCode: couponCode ?? this.couponCode,
      loyaltyPoint: loyaltyPoint ?? this.loyaltyPoint,
    );
  }

  // Helper methods
  bool get hasLoyaltyPoints => loyaltyPoint != null && loyaltyPoint! > 0;
  bool get hasCouponCode => couponCode != null && couponCode!.isNotEmpty;
  String get displayTitle => title.isNotEmpty ? title : 'Try Again';
  String get safeImageUrl => image ?? '';

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    isBetterLuck,
    isSpinAgain,
    image,
    couponCode,
    loyaltyPoint,
  ];

  @override
  String toString() {
    return 'SpinEntity(id: $id, title: $title, type: $type, loyaltyPoint: $loyaltyPoint)';
  }
}
