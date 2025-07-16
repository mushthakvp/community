import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    super.id,
    super.userId,
    super.amount,
    super.type,
    super.through,
    super.currencyCode,
    super.createdAt,
    super.updatedAt,
    super.points,
    super.paymentMethod,
    super.productName,
    super.productImage,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json["_id"],
      userId: json["userId"],
      amount: json["amount"]?.toDouble(),
      type: json["type"],
      through: json["through"],
      currencyCode: json["currencyCode"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      points: json["points"],
      paymentMethod: json["paymentMethod"],
      productName: json["productName"],
      productImage: json["productImage"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": userId,
      "amount": amount,
      "type": type,
      "through": through,
      "currencyCode": currencyCode,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "points": points,
      "paymentMethod": paymentMethod,
      "productName": productName,
      "productImage": productImage,
    };
  }

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      userId: userId,
      amount: amount,
      type: type,
      through: through,
      currencyCode: currencyCode,
      createdAt: createdAt,
      updatedAt: updatedAt,
      points: points,
      paymentMethod: paymentMethod,
      productName: productName,
      productImage: productImage,
    );
  }
}
