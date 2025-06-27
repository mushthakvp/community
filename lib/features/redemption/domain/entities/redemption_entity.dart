import 'transaction_entity.dart';

class RedemptionEntity {
  final bool? success;
  final String? message;
  final int? totalRecords;
  final List<TransactionEntity>? transactions;

  const RedemptionEntity({
    this.success,
    this.message,
    this.totalRecords,
    this.transactions,
  });
}
