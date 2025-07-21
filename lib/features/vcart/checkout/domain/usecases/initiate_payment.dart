import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/order_result.dart';
import '../entities/razorpay_config.dart';
import '../repositories/checkout_repository.dart';

class InitiateRazorpayPayment
    implements UseCase<RazorpayConfig, InitiateRazorpayPaymentParams> {
  final CheckoutRepository repository;

  InitiateRazorpayPayment(this.repository);

  @override
  Future<Either<Failure, RazorpayConfig>> call(
    InitiateRazorpayPaymentParams params,
  ) async {
    return await repository.initiateRazorpayPayment(
      addressId: params.addressId,
    );
  }
}

class InitiateWalletPayment
    implements UseCase<OrderResult, InitiateWalletPaymentParams> {
  final CheckoutRepository repository;

  InitiateWalletPayment(this.repository);

  @override
  Future<Either<Failure, OrderResult>> call(
    InitiateWalletPaymentParams params,
  ) async {
    return await repository.initiateWalletPayment(addressId: params.addressId);
  }
}

class VerifyRazorpayPayment
    implements UseCase<OrderResult, VerifyRazorpayPaymentParams> {
  final CheckoutRepository repository;

  VerifyRazorpayPayment(this.repository);

  @override
  Future<Either<Failure, OrderResult>> call(
    VerifyRazorpayPaymentParams params,
  ) async {
    return await repository.verifyRazorpayPayment(
      orderId: params.orderId,
      paymentId: params.paymentId,
      signature: params.signature,
    );
  }
}

class GetWalletBalance implements UseCase<double, NoParams> {
  final CheckoutRepository repository;

  GetWalletBalance(this.repository);

  @override
  Future<Either<Failure, double>> call(NoParams params) async {
    return await repository.getWalletBalance();
  }
}

class InitiateRazorpayPaymentParams {
  final String addressId;

  const InitiateRazorpayPaymentParams({required this.addressId});
}

class InitiateWalletPaymentParams {
  final String addressId;

  const InitiateWalletPaymentParams({required this.addressId});
}

class VerifyRazorpayPaymentParams {
  final String orderId;
  final String paymentId;
  final String signature;

  const VerifyRazorpayPaymentParams({
    required this.orderId,
    required this.paymentId,
    required this.signature,
  });
}
