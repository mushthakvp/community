import '../../domain/entities/razorpay_config.dart';

class RazorpayConfigModel extends RazorpayConfig {
  const RazorpayConfigModel({
    required super.key,
    required super.orderId,
    required super.amount,
    required super.name,
    required super.description,
    required super.contact,
    required super.email,
  });

  factory RazorpayConfigModel.fromJson(Map<String, dynamic> json) {
    return RazorpayConfigModel(
      key: json['razorPayKey'] ?? '',
      orderId: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      contact: json['contact'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'razorPayKey': key,
      'id': orderId,
      'amount': amount,
      'name': name,
      'description': description,
      'contact': contact,
      'email': email,
    };
  }
}
