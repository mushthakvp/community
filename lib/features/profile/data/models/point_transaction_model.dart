import '../../domain/entities/point_transaction_entity.dart';

class PointTransactionModel extends PointTransactionEntity {
  const PointTransactionModel({
    required super.id,
    required super.userId,
    required super.points,
    required super.through,
    super.amount,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PointTransactionModel.fromJson(Map<String, dynamic> json) {
    return PointTransactionModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      points: json['points'] ?? 0,
      through: json['through'] ?? '',
      amount: json['amount']?.toDouble(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'points': points,
      'through': through,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  PointTransactionEntity toEntity() {
    return PointTransactionEntity(
      id: id,
      userId: userId,
      points: points,
      through: through,
      amount: amount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
