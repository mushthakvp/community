import 'package:equatable/equatable.dart';

import '../../../address/domain/entities/address.dart';
import '../../../cart/domain/entities/cart_data.dart';
import 'payment_method.dart';

class CheckoutData extends Equatable {
  final CartData cartData;
  final List<Address> availableAddresses;
  final Address? selectedAddress;
  final List<PaymentMethod> paymentMethods;
  final PaymentMethod? selectedPaymentMethod;
  final bool isLoading;

  const CheckoutData({
    required this.cartData,
    required this.availableAddresses,
    this.selectedAddress,
    required this.paymentMethods,
    this.selectedPaymentMethod,
    this.isLoading = false,
  });

  bool get hasSelectedAddress => selectedAddress != null;
  bool get hasSelectedPaymentMethod => selectedPaymentMethod != null;
  bool get canProceedToPayment =>
      hasSelectedAddress && hasSelectedPaymentMethod && !isLoading;
  bool get hasAddresses => availableAddresses.isNotEmpty;

  @override
  List<Object?> get props => [
    cartData,
    availableAddresses,
    selectedAddress,
    paymentMethods,
    selectedPaymentMethod,
    isLoading,
  ];

  CheckoutData copyWith({
    CartData? cartData,
    List<Address>? availableAddresses,
    Address? selectedAddress,
    List<PaymentMethod>? paymentMethods,
    PaymentMethod? selectedPaymentMethod,
    bool? isLoading,
  }) {
    return CheckoutData(
      cartData: cartData ?? this.cartData,
      availableAddresses: availableAddresses ?? this.availableAddresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
