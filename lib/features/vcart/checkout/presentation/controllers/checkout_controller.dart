import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../address/domain/entities/address.dart';
import '../../../cart/domain/entities/cart_data.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../domain/entities/checkout_data.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/usecases/get_checkout_data.dart';
import '../../domain/usecases/initiate_payment.dart';

class VCartCheckoutController extends GetxController {
  final GetCheckoutData getCheckoutDataUseCase;
  final InitiateRazorpayPayment initiateRazorpayPaymentUseCase;
  final InitiateWalletPayment initiateWalletPaymentUseCase;
  final VerifyRazorpayPayment verifyRazorpayPaymentUseCase;
  final GetWalletBalance getWalletBalanceUseCase;

  VCartCheckoutController({
    required this.getCheckoutDataUseCase,
    required this.initiateRazorpayPaymentUseCase,
    required this.initiateWalletPaymentUseCase,
    required this.verifyRazorpayPaymentUseCase,
    required this.getWalletBalanceUseCase,
  });

  // Observable variables
  final _isLoading = false.obs;
  final _checkoutData = Rxn<CheckoutData>();
  final _errorMessage = ''.obs;
  final _hasError = false.obs;
  final _selectedAddress = Rxn<Address>();
  final _selectedPaymentMethod = Rxn<PaymentMethod>();
  final _walletBalance = 0.0.obs;

  // Razorpay instance
  late Razorpay _razorpay;
  BuildContext? _context;

  // Getters
  bool get isLoading => _isLoading.value;
  CheckoutData? get checkoutData => _checkoutData.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _hasError.value;
  Address? get selectedAddress => _selectedAddress.value;
  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod.value;
  double get walletBalance => _walletBalance.value;

  // Computed properties
  List<Address> get addresses => checkoutData?.availableAddresses ?? [];
  bool get hasAddresses => addresses.isNotEmpty;
  bool get canProceedToPayment =>
      selectedAddress != null && selectedPaymentMethod != null && !isLoading;

  @override
  void onInit() {
    super.onInit();
    _initializeRazorpay();
    _initializePaymentMethods();
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _initializePaymentMethods() {
    final paymentMethods = [
      const PaymentMethod(
        type: PaymentType.razorpay,
        name: 'Razorpay',
        isEnabled: true,
      ),
      PaymentMethod(
        type: PaymentType.wallet,
        name: 'Wallet',
        walletBalance: walletBalance,
        isEnabled: true,
      ),
    ];

    _selectedPaymentMethod.value = paymentMethods.first;
  }

  Future<void> loadCheckoutData(CartData cartData) async {
    try {
      _setLoading(true);
      _clearError();

      // Load addresses
      final addressResult = await getCheckoutDataUseCase(
        const GetCheckoutDataParams(),
      );

      // Load wallet balance
      final walletResult = await getWalletBalanceUseCase(NoParams());

      addressResult.fold((failure) => _handleFailure(failure), (addresses) {
        walletResult.fold(
          (failure) => _walletBalance.value = 0.0,
          (balance) => _walletBalance.value = balance,
        );

        final paymentMethods = [
          const PaymentMethod(
            type: PaymentType.razorpay,
            name: 'Razorpay',
            isEnabled: true,
          ),
          PaymentMethod(
            type: PaymentType.wallet,
            name: 'Wallet',
            walletBalance: _walletBalance.value,
            isEnabled: true,
          ),
        ];

        _checkoutData.value = CheckoutData(
          cartData: cartData,
          availableAddresses: addresses,
          selectedAddress: addresses.isNotEmpty ? addresses.first : null,
          paymentMethods: paymentMethods,
          selectedPaymentMethod: paymentMethods.first,
        );

        if (addresses.isNotEmpty) {
          _selectedAddress.value = addresses.first;
        }

        _setLoading(false);
      });
    } catch (e) {
      _handleError('Unexpected error occurred: $e');
    }
  }

  void selectAddress(Address address) {
    _selectedAddress.value = address;
    _checkoutData.value = checkoutData?.copyWith(selectedAddress: address);
  }

  void selectPaymentMethod(PaymentMethod paymentMethod) {
    _selectedPaymentMethod.value = paymentMethod;
    _checkoutData.value = checkoutData?.copyWith(
      selectedPaymentMethod: paymentMethod,
    );
  }

  Future<void> processPayment(BuildContext context) async {
    if (!canProceedToPayment) return;

    _context = context;
    _setLoading(true);

    try {
      if (selectedPaymentMethod!.isRazorpay) {
        await _processRazorpayPayment();
      } else if (selectedPaymentMethod!.isWallet) {
        await _processWalletPayment(context);
      }
    } catch (e) {
      _setLoading(false);
      _handleError('Payment processing failed: $e');
      context.showVCartSnackBar(
        'Payment failed. Please try again.',
        isError: true,
      );
    }
  }

  Future<void> _processRazorpayPayment() async {
    final result = await initiateRazorpayPaymentUseCase(
      InitiateRazorpayPaymentParams(addressId: selectedAddress!.id!),
    );

    result.fold(
      (failure) {
        _setLoading(false);
        _handleFailure(failure);
      },
      (config) {
        _setLoading(false);
        _razorpay.open(config.toRazorpayOptions());
      },
    );
  }

  Future<void> _processWalletPayment(BuildContext context) async {
    final result = await initiateWalletPaymentUseCase(
      InitiateWalletPaymentParams(addressId: selectedAddress!.id!),
    );

    result.fold(
      (failure) {
        _setLoading(false);
        _handleFailure(failure);
        context.showVCartSnackBar(failure.message, isError: true);
      },
      (orderResult) {
        _setLoading(false);
        if (orderResult.success && orderResult.orderId != null) {
          _navigateToOrderSuccess(context, orderResult.orderId!);
        } else {
          context.showVCartSnackBar(
            orderResult.message ?? 'Payment failed',
            isError: true,
          );
        }
      },
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (_context == null) return;

    _setLoading(true);

    final result = await verifyRazorpayPaymentUseCase(
      VerifyRazorpayPaymentParams(
        orderId: response.orderId ?? '',
        paymentId: response.paymentId ?? '',
        signature: response.signature ?? '',
      ),
    );

    result.fold(
      (failure) {
        _setLoading(false);
        _context!.showVCartSnackBar(failure.message, isError: true);
      },
      (orderResult) {
        _setLoading(false);
        if (orderResult.success && orderResult.orderId != null) {
          _navigateToOrderSuccess(_context!, orderResult.orderId!);
        } else {
          _context!.showVCartSnackBar(
            orderResult.message ?? 'Payment verification failed',
            isError: true,
          );
        }
      },
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _setLoading(false);
    _context?.showVCartSnackBar(
      'Payment failed: ${response.message}',
      isError: true,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _setLoading(false);
    _context?.showVCartSnackBar(
      'External wallet selected: ${response.walletName}',
    );
  }

  void _navigateToOrderSuccess(BuildContext context, String orderId) {
    context.go('/order-success/$orderId');
  }

  void navigateToAddAddress(BuildContext context) {
    context.push('/address/add').then((_) {
      // Reload addresses after adding new one
      if (checkoutData != null) {
        loadCheckoutData(checkoutData!.cartData);
      }
    });
  }

  // Location methods
  Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }

  void _handleFailure(Failure failure) {
    _setLoading(false);
    _handleError(failure.message);
  }

  void _handleError(String message) {
    _hasError.value = true;
    _errorMessage.value = message;
    _setLoading(false);
  }
}
