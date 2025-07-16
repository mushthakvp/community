import 'package:equatable/equatable.dart';

import 'spin_entity.dart';

class SpinResultEntity extends Equatable {
  final bool success;
  final String message;
  final SpinEntity? spinOption;
  final int? loyaltyPointsEarned;
  final String? couponCodeEarned;

  const SpinResultEntity({
    required this.success,
    required this.message,
    this.spinOption,
    this.loyaltyPointsEarned,
    this.couponCodeEarned,
  });

  SpinResultEntity copyWith({
    bool? success,
    String? message,
    SpinEntity? spinOption,
    int? loyaltyPointsEarned,
    String? couponCodeEarned,
  }) {
    return SpinResultEntity(
      success: success ?? this.success,
      message: message ?? this.message,
      spinOption: spinOption ?? this.spinOption,
      loyaltyPointsEarned: loyaltyPointsEarned ?? this.loyaltyPointsEarned,
      couponCodeEarned: couponCodeEarned ?? this.couponCodeEarned,
    );
  }

  bool get isWin =>
      success && (loyaltyPointsEarned != null || couponCodeEarned != null);
  bool get isBetterLuck => spinOption?.isBetterLuck == true;
  bool get isSpinAgain => spinOption?.isSpinAgain == true;

  @override
  List<Object?> get props => [
    success,
    message,
    spinOption,
    loyaltyPointsEarned,
    couponCodeEarned,
  ];
}
