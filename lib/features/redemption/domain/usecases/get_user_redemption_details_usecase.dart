import '../../../../core/utils/result.dart';
import '../entities/user_details_entity.dart';
import '../repositories/redemption_repository.dart';

class GetUserRedemptionDetailsUseCase {
  final RedemptionRepository repository;

  GetUserRedemptionDetailsUseCase(this.repository);

  Future<Result<UserDetailsEntity>> call() async {
    return await repository.getUserRedemptionDetails();
  }
}
