import 'package:equatable/equatable.dart';

class OrderResult extends Equatable {
  final bool success;
  final String? orderId;
  final String? message;
  final String? paymentId;
  final String? signature;

  const OrderResult({
    required this.success,
    this.orderId,
    this.message,
    this.paymentId,
    this.signature,
  });

  @override
  List<Object?> get props => [success, orderId, message, paymentId, signature];
}
