import 'package:equatable/equatable.dart';

class PointTransactionEntity extends Equatable {
  final String id;
  final String userId;
  final int points;
  final String through;
  final double? amount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PointTransactionEntity({
    required this.id,
    required this.userId,
    required this.points,
    required this.through,
    this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    points,
    through,
    amount,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'PointTransactionEntity(id: $id, userId: $userId, points: $points, '
        'through: $through, amount: $amount, createdAt: $createdAt, '
        'updatedAt: $updatedAt)';
  }
}
