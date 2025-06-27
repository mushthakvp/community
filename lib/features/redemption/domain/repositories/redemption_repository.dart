
import '../../../../core/utils/result.dart';
import '../entities/redemption_entity.dart';
import '../entities/user_details_entity.dart';
import '../entities/wallet_recharge_entity.dart';

abstract class RedemptionRepository {
  /// Get user wallet transactions with filters
  Future<Result<RedemptionEntity>> getWalletTransactions({
    String filter = 'All',
    String? fromDate,
    String? toDate,
    int page = 1,
  });

  Future<Result<UserDetailsEntity>> getUserRedemptionDetails();

  Future<Result<WalletRechargeEntity>> initiateWalletRecharge({
    required double amount,
  });

  Future<Result<WalletRechargeEntity>> initiateTierUpgrade();

  Future<Result<Map<String, dynamic>>> verifyPayment({
    required Map<String, dynamic> paymentDetails,
  });
}