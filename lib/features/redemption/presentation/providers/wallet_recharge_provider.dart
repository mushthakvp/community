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
  bool _isInitialized = false;

  // Payment success callback
  Function()? _onPaymentSuccess;

  // Default amounts for quick selection - FIXED: Added all 6 amounts
  final List<String> defaultAmounts = [
    "100",
    "250",
    "500",
    "1000",
    "2000",
    "5000",
  ];

  // Getters
  bool get isProcessingPayment => _isProcessingPayment;
  bool get isStripePayment => _isStripePayment;
  String? get error => _error;
  WalletRechargeEntity? get paymentData => _paymentData;
  bool get isInitialized => _isInitialized;

  // FIXED: Initialize Razorpay safely without calling resetState in constructor
  void initializeRazorpay() {
    if (!_isInitialized) {
      try {
        _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
        _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
        _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
        _isInitialized = true;
      } catch (e) {
        log('Error initializing Razorpay: $e');
      }
    }
  }

  // FIXED: Safe reset that doesn't trigger during provider creation
  void resetState() {
    _isProcessingPayment = false;
    _isStripePayment = false;
    _error = null;
    _paymentData = null;
    _onPaymentSuccess = null;
    rechargeAmountController.clear();

    // Only notify listeners if we're initialized and not during provider creation
    if (_isInitialized) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _razorpay.clear();
    }
    rechargeAmountController.dispose();
    super.dispose();
  }

  // Select predefined amount with animation
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
    if (_isProcessingPayment) return;

    if (!isTierUpgrade) {
      final amount = double.tryParse(rechargeAmountController.text.trim());
      if (amount == null || amount <= 0) {
        _error = 'Please enter a valid amount';
        notifyListeners();
        return;
      }
    }

    _isProcessingPayment = true;
    _error = null;
    _onPaymentSuccess = onSuccess;
    notifyListeners();

    try {
      Result<WalletRechargeEntity> result;

      if (isTierUpgrade) {
        result = await initiateTierUpgradeUseCase();
      } else {
        final amount = double.parse(rechargeAmountController.text.trim());
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
      _error = 'Error initiating payment: ${e.toString()}';
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
    if (data.options?.description?.toLowerCase().contains('stripe') == true) {
      _isStripePayment = true;
      _handleStripePayment(data);
    } else {
      _isStripePayment = false;
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

    try {
      final options = {
        "key": data.options!.key ?? '',
        "amount": data.options?.amount ?? 0,
        "order_id": data.order?.id ?? '',
        "name": data.options?.name ?? 'Community App',
        "description": data.options?.description ?? 'Wallet Recharge',
        "prefill": {
          "contact": data.options?.contact ?? '',
          "email": data.options?.email ?? '',
        },
      };
      _razorpay.open(options);
    } catch (e) {
      _error = 'Error opening Razorpay: ${e.toString()}';
      _isProcessingPayment = false;
      notifyListeners();
    }
  }

  // Handle Stripe payment
  void _handleStripePayment(WalletRechargeEntity data) {
    _error = 'Stripe payment not implemented yet';
    _isProcessingPayment = false;
    notifyListeners();
  }

  // Razorpay success handler
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
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
    _error = 'Payment failed: ${response.message ?? 'Unknown error'}';
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
