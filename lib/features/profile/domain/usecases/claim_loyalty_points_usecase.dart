import '../../../../core/utils/result.dart';
import '../repositories/profile_repository.dart';

class ClaimLoyaltyPointsUseCase {
  final ProfileRepository repository;

  ClaimLoyaltyPointsUseCase(this.repository);

  Future<Result<void>> call() async {
    return await repository.claimLoyaltyPoints();
  }
}
