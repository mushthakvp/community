import '../../../../core/error/error_handler.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/redemption_entity.dart';
import '../../domain/entities/user_details_entity.dart';
import '../../domain/entities/wallet_recharge_entity.dart';
import '../../domain/repositories/redemption_repository.dart';
import '../datasources/redemption_local_datasource.dart';
import '../datasources/redemption_remote_datasource.dart';

class RedemptionRepositoryImpl implements RedemptionRepository {
  final RedemptionRemoteDataSource remoteDataSource;
  final RedemptionLocalDataSource localDataSource;

  RedemptionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<RedemptionEntity>> getWalletTransactions({
    String filter = 'All',
    String? fromDate,
    String? toDate,
    int page = 1,
  }) async {
    try {
      bool shouldUseCache =
          page == 1 && filter == 'All' && fromDate == null && toDate == null;

      if (shouldUseCache) {
        final cachedData = await localDataSource.getCachedWalletTransactions();
        if (cachedData != null) {
          return Success(cachedData.toEntity());
        }
      }

      final remoteData = await remoteDataSource.getWalletTransactions(
        filter: filter,
        fromDate: fromDate,
        toDate: toDate,
        page: page,
      );

      if (shouldUseCache) {
        await localDataSource.cacheWalletTransactions(remoteData);
      }

      return Success(remoteData.toEntity());
    } catch (e) {
      final failure = ErrorHandler.handleException(e as Exception);
      return Error(message: failure.message);
    }
  }

  @override
  Future<Result<UserDetailsEntity>> getUserRedemptionDetails() async {
    try {
      final remoteData = await remoteDataSource.getUserRedemptionDetails();
      await localDataSource.cacheUserDetails(remoteData);
      return Success(remoteData.toEntity());
    } catch (e) {
      try {
        final cachedData = await localDataSource.getCachedUserDetails();
        if (cachedData != null) {
          return Success(cachedData.toEntity());
        }
      } catch (cacheError) {
        final failure = ErrorHandler.handleException(cacheError as Exception);
        return Error(message: failure.message);
      }
      final failure = ErrorHandler.handleException(e as Exception);
      return Error(message: failure.message);
    }
  }

  @override
  Future<Result<WalletRechargeEntity>> initiateWalletRecharge({
    required double amount,
  }) async {
    try {
      final result = await remoteDataSource.initiateWalletRecharge(
        amount: amount,
      );
      return Success(result.toEntity());
    } catch (e) {
      final failure = ErrorHandler.handleException(e as Exception);
      return Error(message: failure.message);
    }
  }

  @override
  Future<Result<WalletRechargeEntity>> initiateTierUpgrade() async {
    try {
      final result = await remoteDataSource.initiateTierUpgrade();
      return Success(result.toEntity());
    } catch (e) {
      final failure = ErrorHandler.handleException(e as Exception);
      return Error(message: failure.message);
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> verifyPayment({
    required Map<String, dynamic> paymentDetails,
  }) async {
    try {
      final result = await remoteDataSource.verifyPayment(
        paymentDetails: paymentDetails,
      );
      await localDataSource.clearCache();
      return Success(result);
    } catch (e) {
      final failure = ErrorHandler.handleException(e as Exception);
      return Error(message: failure.message);
    }
  }
}
