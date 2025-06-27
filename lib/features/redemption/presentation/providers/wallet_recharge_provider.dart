import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/wallet_recharge_entity.dart';
import '../../domain/usecases/initiate_tier_upgrade_usecase.dart';
import '../../domain/usecases/initiate_wallet_recharge_usecase.dart';
import '../../domain/usecases/verify_payment_usecase.dart';

class WalletRechargeProvider extends ChangeNotifier {
  final InitiateWalletRechargeUseCase initiateWalletRechargeUseCase;
  final InitiateTierUpgradeUseCase initiateTierUpgradeUseCase;
  final VerifyPaymentUseCase verifyPaymentUseCase;

  WalletRechargeProvider({
    required this.initiateWalletRechargeUseCase,
    required this.initiateTierUpgradeUseCase,
    required this.verifyPaymentUseCase,
  });

  final Razorpay _razorpay = Razorpay();
  final TextEditingController rechargeAmountController =
      TextEditingController();

  // States
  bool _isProcessingPayment = false;
  bool _isStripePayment = false;
  String? _error;
  WalletRechargeEntity? _paymentData;

  // Payment success callback
  Function()? _onPaymentSuccess;

  // Default amounts for quick selection
  final List<String> defaultAmounts = [
    "100",
    "250",
    "500",
    "1000",
    "2000",
    "5000",
    "10000",
  ];

  // Getters
  bool get isProcessingPayment => _isProcessingPayment;
  bool get isStripePayment => _isStripePayment;
  String? get error => _error;
  WalletRechargeEntity? get paymentData => _paymentData;

  @override
  void dispose() {
    _razorpay.clear();
    rechargeAmountController.dispose();
    super.dispose();
  }

  // Initialize Razorpay listeners
  void initializeRazorpay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // Select predefined amount
  void selectAmount(String amount) {
    rechargeAmountController.text = amount;
    notifyListeners();
  }

  // Initiate payment process
  Future<void> initiatePayment({
    bool isTierUpgrade = false,
    String purpose = 'Recharge',
    Function()? onSuccess,
  }) async {
    _isProcessingPayment = true;
    _error = null;
    _onPaymentSuccess = onSuccess;
    notifyListeners();
    try {
      Result<WalletRechargeEntity> result;
      if (isTierUpgrade) {
        result = await initiateTierUpgradeUseCase();
      } else {
        final amount = double.tryParse(rechargeAmountController.text.trim());
        if (amount == null || amount <= 0) {
          throw Exception('Please enter a valid amount');
        }
        result = await initiateWalletRechargeUseCase(amount: amount);
      }
      result.fold(
        onSuccess: (data) {
          _paymentData = data;
          _processPayment(data, isTierUpgrade, purpose);
        },
        onError: (error) {
          _error = error;
          _isProcessingPayment = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _error = e.toString();
      _isProcessingPayment = false;
      notifyListeners();
    }
  }

  // Process payment based on type (Razorpay or Stripe)
  void _processPayment(
    WalletRechargeEntity data,
    bool isTierUpgrade,
    String purpose,
  ) {
    // Check if it's a Stripe payment (has URL)
    if (data.options?.description?.contains('stripe') == true) {
      _isStripePayment = true;
      // Handle Stripe payment
      _handleStripePayment(data);
    } else {
      _isStripePayment = false;
      // Handle Razorpay payment
      _handleRazorpayPayment(data);
    }
  }

  // Handle Razorpay payment
  void _handleRazorpayPayment(WalletRechargeEntity data) {
    if (data.options == null || data.order == null) {
      _error = 'Invalid payment data received';
      _isProcessingPayment = false;
      notifyListeners();
      return;
    }

    final options = {
      "key": data.options!.key ?? '',
      "amount": data.options?.amount ?? 0,
      "order_id": data.order?.id ?? '',
      "name": data.options?.name ?? 'Community',
      "description": data.options?.description ?? '',
      "prefill": {
        "contact": data.options?.contact ?? '',
        "email": data.options?.email ?? '',
      },
    };
    _razorpay.open(options);
  }

  // Handle Stripe payment
  void _handleStripePayment(WalletRechargeEntity data) {
    log('Handling Stripe payment: ${data.toString()}');
    _isProcessingPayment = false;
    notifyListeners();
  }

  // Razorpay success handler
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    log('Payment successful: ${response.paymentId}');

    try {
      final paymentDetails = {
        "amount": rechargeAmountController.text.trim(),
        "razorpay_payment_id": response.paymentId ?? "",
        "razorpay_order_id": response.orderId ?? '',
        "razorpay_signature": response.signature ?? '',
        "currency": "INR",
        "purpose": 'Recharge',
      };

      final result = await verifyPaymentUseCase(paymentDetails: paymentDetails);

      result.fold(
        onSuccess: (data) {
          _onPaymentSuccess?.call();
          rechargeAmountController.clear();
          _error = null;
        },
        onError: (error) {
          _error = 'Payment verification failed: $error';
        },
      );
    } catch (e) {
      _error = 'Error verifying payment: ${e.toString()}';
    }

    _isProcessingPayment = false;
    notifyListeners();
  }

  // Razorpay error handler
  void _handlePaymentError(PaymentFailureResponse response) {
    log('Payment failed: ${response.message}');
    _error = 'Payment failed: ${response.message}';
    _isProcessingPayment = false;
    notifyListeners();
  }

  // External wallet handler
  void _handleExternalWallet(ExternalWalletResponse response) {
    log('External wallet selected: ${response.walletName}');
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

// Stripe response model (if needed)
class StripeResponseModel {
  final bool? success;
  final String? currency;
  final String? url;
  final String? successUrl;
  final String? cancelUrl;

  StripeResponseModel({
    this.success,
    this.currency,
    this.url,
    this.successUrl,
    this.cancelUrl,
  });

  factory StripeResponseModel.fromJson(Map<String, dynamic> json) {
    return StripeResponseModel(
      success: json['success'],
      currency: json['currency'],
      url: json['url'],
      successUrl: json['successUrl'],
      cancelUrl: json['cancelUrl'],
    );
  }
}
