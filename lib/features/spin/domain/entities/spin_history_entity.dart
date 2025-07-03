import 'package:equatable/equatable.dart';

import 'spin_result_entity.dart';

class SpinHistoryEntity extends Equatable {
  final String id;
  final List<SpinResultEntity> results;
  final DateTime date;
  final int totalSpins;
  final int winningSpins;
  final int loyaltyPointsEarned;
  final List<String> couponsEarned;

  const SpinHistoryEntity({
    required this.id,
    required this.results,
    required this.date,
    required this.totalSpins,
    required this.winningSpins,
    required this.loyaltyPointsEarned,
    required this.couponsEarned,
  });

  SpinHistoryEntity copyWith({
    String? id,
    List<SpinResultEntity>? results,
    DateTime? date,
    int? totalSpins,
    int? winningSpins,
    int? loyaltyPointsEarned,
    List<String>? couponsEarned,
  }) {
    return SpinHistoryEntity(
      id: id ?? this.id,
      results: results ?? this.results,
      date: date ?? this.date,
      totalSpins: totalSpins ?? this.totalSpins,
      winningSpins: winningSpins ?? this.winningSpins,
      loyaltyPointsEarned: loyaltyPointsEarned ?? this.loyaltyPointsEarned,
      couponsEarned: couponsEarned ?? this.couponsEarned,
    );
  }

  // Helper methods
  double get winningPercentage =>
      totalSpins > 0 ? (winningSpins / totalSpins) * 100 : 0;

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return 'Today';
    } else if (targetDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  List<Object?> get props => [
    id,
    results,
    date,
    totalSpins,
    winningSpins,
    loyaltyPointsEarned,
    couponsEarned,
  ];
}
