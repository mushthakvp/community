import '../../../../core/utils/result.dart';
import '../entities/loyalty_card_entity.dart';
import '../repositories/profile_repository.dart';

class GetLoyaltyCardUseCase {
  final ProfileRepository repository;

  GetLoyaltyCardUseCase(this.repository);

  Future<Result<LoyaltyCardEntity>> call() async {
    return await repository.getLoyaltyCard();
  }
}
