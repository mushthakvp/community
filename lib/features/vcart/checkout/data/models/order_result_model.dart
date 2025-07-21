import '../../domain/entities/order_result.dart';

class OrderResultModel extends OrderResult {
  const OrderResultModel({
    required super.success,
    super.orderId,
    super.message,
    super.paymentId,
    super.signature,
  });

  factory OrderResultModel.fromJson(
    Map<String, dynamic> json, {
    bool isSuccess = false,
  }) {
    return OrderResultModel(
      success: isSuccess || (json['success'] ?? false),
      orderId: json['orderId'] ?? json['order_id'],
      message: json['message'],
      paymentId: json['paymentId'] ?? json['payment_id'],
      signature: json['signature'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'orderId': orderId,
      'message': message,
      'paymentId': paymentId,
      'signature': signature,
    };
  }
}
