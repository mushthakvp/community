import 'package:equatable/equatable.dart';

enum PaymentType { razorpay, wallet }

class PaymentMethod extends Equatable {
  final PaymentType type;
  final String name;
  final String? icon;
  final bool isEnabled;
  final double? walletBalance;

  const PaymentMethod({
    required this.type,
    required this.name,
    this.icon,
    this.isEnabled = true,
    this.walletBalance,
  });

  bool get isWallet => type == PaymentType.wallet;
  bool get isRazorpay => type == PaymentType.razorpay;

  String get displayBalance {
    if (isWallet && walletBalance != null) {
      return 'Balance: ₹${walletBalance!.toStringAsFixed(2)}';
    }
    return '';
  }

  @override
  List<Object?> get props => [type, name, icon, isEnabled, walletBalance];

  PaymentMethod copyWith({
    PaymentType? type,
    String? name,
    String? icon,
    bool? isEnabled,
    double? walletBalance,
  }) {
    return PaymentMethod(
      type: type ?? this.type,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isEnabled: isEnabled ?? this.isEnabled,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }
}
