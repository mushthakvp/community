import '../../../../core/utils/result.dart';
import '../repositories/redemption_repository.dart';

class VerifyPaymentUseCase {
  final RedemptionRepository repository;

  VerifyPaymentUseCase(this.repository);

  Future<Result<Map<String, dynamic>>> call({
    required Map<String, dynamic> paymentDetails,
  }) async {
    return await repository.verifyPayment(paymentDetails: paymentDetails);
  }
}
