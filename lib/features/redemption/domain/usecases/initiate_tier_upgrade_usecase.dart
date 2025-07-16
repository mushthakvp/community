import '../../../../core/utils/result.dart';
import '../entities/wallet_recharge_entity.dart';
import '../repositories/redemption_repository.dart';

class InitiateTierUpgradeUseCase {
  final RedemptionRepository repository;

  InitiateTierUpgradeUseCase(this.repository);

  Future<Result<WalletRechargeEntity>> call() async {
    return await repository.initiateTierUpgrade();
  }
}
