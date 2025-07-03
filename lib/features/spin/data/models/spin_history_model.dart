import '../../domain/entities/spin_history_entity.dart';
import 'spin_result_model.dart';

class SpinHistoryModel extends SpinHistoryEntity {
  const SpinHistoryModel({
    required super.id,
    required super.results,
    required super.date,
    required super.totalSpins,
    required super.winningSpins,
    required super.loyaltyPointsEarned,
    required super.couponsEarned,
  });

  factory SpinHistoryModel.fromJson(Map<String, dynamic> json) {
    return SpinHistoryModel(
      id: json['id'] ?? json['_id'] ?? '',
      results:
          (json['results'] as List<dynamic>?)
              ?.map((result) => SpinResultModel.fromJson(result))
              .toList() ??
          [],
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      totalSpins: json['totalSpins'] ?? 0,
      winningSpins: json['winningSpins'] ?? 0,
      loyaltyPointsEarned: json['loyaltyPointsEarned'] ?? 0,
      couponsEarned: List<String>.from(json['couponsEarned'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'results': results
          .map((result) => SpinResultModel.fromEntity(result).toJson())
          .toList(),
      'date': date.toIso8601String(),
      'totalSpins': totalSpins,
      'winningSpins': winningSpins,
      'loyaltyPointsEarned': loyaltyPointsEarned,
      'couponsEarned': couponsEarned,
    };
  }

  SpinHistoryEntity toEntity() {
    return SpinHistoryEntity(
      id: id,
      results: results,
      date: date,
      totalSpins: totalSpins,
      winningSpins: winningSpins,
      loyaltyPointsEarned: loyaltyPointsEarned,
      couponsEarned: couponsEarned,
    );
  }

  factory SpinHistoryModel.fromEntity(SpinHistoryEntity entity) {
    return SpinHistoryModel(
      id: entity.id,
      results: entity.results,
      date: entity.date,
      totalSpins: entity.totalSpins,
      winningSpins: entity.winningSpins,
      loyaltyPointsEarned: entity.loyaltyPointsEarned,
      couponsEarned: entity.couponsEarned,
    );
  }
}
