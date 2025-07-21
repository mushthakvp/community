import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../address/domain/entities/address.dart';
import '../entities/order_result.dart';
import '../entities/razorpay_config.dart';

abstract class CheckoutRepository {
  Future<Either<Failure, List<Address>>> getAddresses({
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, RazorpayConfig>> initiateRazorpayPayment({
    required String addressId,
  });

  Future<Either<Failure, OrderResult>> initiateWalletPayment({
    required String addressId,
  });

  Future<Either<Failure, OrderResult>> verifyRazorpayPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  });

  Future<Either<Failure, double>> getWalletBalance();
}
