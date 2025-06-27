import '../../domain/entities/redemption_entity.dart';
import 'transaction_model.dart';

class RedemptionModel extends RedemptionEntity {
  const RedemptionModel({
    super.success,
    super.message,
    super.totalRecords,
    super.transactions,
  });

  factory RedemptionModel.fromJson(Map<String, dynamic> json) {
    return RedemptionModel(
      success: json["success"],
      message: json["message"],
      totalRecords: json["totalRecords"],
      transactions: json["transactions"] == null
          ? []
          : List<TransactionModel>.from(
              json["transactions"]!.map((x) => TransactionModel.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "totalRecords": totalRecords,
      "transactions": transactions == null
          ? []
          : List<dynamic>.from(
              transactions!.map((x) => (x as TransactionModel).toJson()),
            ),
    };
  }

  RedemptionEntity toEntity() {
    return RedemptionEntity(
      success: success,
      message: message,
      totalRecords: totalRecords,
      transactions: transactions
          ?.map((t) => (t as TransactionModel).toEntity())
          .toList(),
    );
  }
}
