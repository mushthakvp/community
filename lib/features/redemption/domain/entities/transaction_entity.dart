class TransactionEntity {
  final String? id;
  final String? userId;
  final double? amount;
  final String? type;
  final String? through;
  final String? currencyCode;
  final String? createdAt;
  final String? updatedAt;
  final int? points;
  final String? paymentMethod;
  final String? productName;
  final String? productImage;

  const TransactionEntity({
    this.id,
    this.userId,
    this.amount,
    this.type,
    this.through,
    this.currencyCode,
    this.createdAt,
    this.updatedAt,
    this.points,
    this.paymentMethod,
    this.productName,
    this.productImage,
  });
}
