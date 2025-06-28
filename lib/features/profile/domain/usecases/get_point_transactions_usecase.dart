import '../../../../core/utils/result.dart';
import '../entities/point_transaction_entity.dart';
import '../repositories/profile_repository.dart';

class GetPointTransactionsUseCase {
  final ProfileRepository repository;

  GetPointTransactionsUseCase(this.repository);

  Future<Result<List<PointTransactionEntity>>> call({
    required String status,
    required int page,
  }) async {
    return await repository.getLoyaltyPointTransactions(
      status: status,
      page: page,
    );
  }
}
