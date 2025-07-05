import 'package:equatable/equatable.dart';

import 'spin_entity.dart';

class SpinDataEntity extends Equatable {
  final bool success;
  final List<SpinEntity> options;
  final int userLoyaltyPoints;
  final bool canSpin;
  final String? message;
  final int requiredPoints;

  const SpinDataEntity({
    required this.success,
    required this.options,
    required this.userLoyaltyPoints,
    required this.canSpin,
    this.message,
    required this.requiredPoints,
  });

  SpinDataEntity copyWith({
    bool? success,
    List<SpinEntity>? options,
    int? userLoyaltyPoints,
    bool? canSpin,
    String? message,
    int? requiredPoints,
  }) {
    return SpinDataEntity(
      success: success ?? this.success,
      options: options ?? this.options,
      userLoyaltyPoints: userLoyaltyPoints ?? this.userLoyaltyPoints,
      canSpin: canSpin ?? this.canSpin,
      message: message ?? this.message,
      requiredPoints: requiredPoints ?? this.requiredPoints,
    );
  }

  bool get hasOptions => options.isNotEmpty;
  bool get hasEnoughPoints => userLoyaltyPoints >= requiredPoints;

  @override
  List<Object?> get props => [
    success,
    options,
    userLoyaltyPoints,
    canSpin,
    message,
    requiredPoints,
  ];
}
