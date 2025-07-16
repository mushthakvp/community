import '../../../../core/utils/result.dart';
import '../entities/redemption_entity.dart';
import '../repositories/redemption_repository.dart';

class GetWalletTransactionsUseCase {
  final RedemptionRepository repository;

  GetWalletTransactionsUseCase(this.repository);

  Future<Result<RedemptionEntity>> call({
    String filter = 'All',
    String? fromDate,
    String? toDate,
    int page = 1,
  }) async {
    return await repository.getWalletTransactions(
      filter: filter,
      fromDate: fromDate,
      toDate: toDate,
      page: page,
    );
  }
}
