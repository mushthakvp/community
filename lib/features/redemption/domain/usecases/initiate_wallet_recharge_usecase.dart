import '../../../../core/utils/result.dart';
import '../entities/wallet_recharge_entity.dart';
import '../repositories/redemption_repository.dart';

class InitiateWalletRechargeUseCase {
  final RedemptionRepository repository;

  InitiateWalletRechargeUseCase(this.repository);

  Future<Result<WalletRechargeEntity>> call({
    required double amount,
  }) async {
    return await repository.initiateWalletRecharge(amount: amount);
  }
}
