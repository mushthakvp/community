import 'package:equatable/equatable.dart';

class RazorpayConfig extends Equatable {
  final String key;
  final String orderId;
  final double amount;
  final String name;
  final String description;
  final String contact;
  final String email;

  const RazorpayConfig({
    required this.key,
    required this.orderId,
    required this.amount,
    required this.name,
    required this.description,
    required this.contact,
    required this.email,
  });

  Map<String, dynamic> toRazorpayOptions() {
    return {
      'key': key,
      'amount': (amount * 100).toInt(),
      'order_id': orderId,
      'name': name,
      'description': description,
      'prefill': {'contact': contact, 'email': email, 'name': name},
    };
  }

  @override
  List<Object?> get props => [
    key,
    orderId,
    amount,
    name,
    description,
    contact,
    email,
  ];
}
