import 'package:equatable/equatable.dart';

import 'spin_option_entity.dart';

class SpinHistoryEntity extends Equatable {
  final String id;
  final String userId;
  final SpinOptionEntity? spinOption;
  final String spinType;
  final String resultType;
  final int? loyaltyPoint;
  final String? couponCode;
  final DateTime date;

  const SpinHistoryEntity({
    required this.id,
    required this.userId,
    this.spinOption,
    required this.spinType,
    required this.resultType,
    this.loyaltyPoint,
    this.couponCode,
    required this.date,
  });

  SpinHistoryEntity copyWith({
    String? id,
    String? userId,
    SpinOptionEntity? spinOption,
    String? spinType,
    String? resultType,
    int? loyaltyPoint,
    String? couponCode,
    DateTime? date,
  }) {
    return SpinHistoryEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      spinOption: spinOption ?? this.spinOption,
      spinType: spinType ?? this.spinType,
      resultType: resultType ?? this.resultType,
      loyaltyPoint: loyaltyPoint ?? this.loyaltyPoint,
      couponCode: couponCode ?? this.couponCode,
      date: date ?? this.date,
    );
  }

  bool get hasReward => loyaltyPoint != null || couponCode != null;
  bool get isWin => !resultType.toLowerCase().contains('better luck');
  String get displayResult => spinOption?.title ?? 'Unknown';

  @override
  List<Object?> get props => [
    id,
    userId,
    spinOption,
    spinType,
    resultType,
    loyaltyPoint,
    couponCode,
    date,
  ];
}
