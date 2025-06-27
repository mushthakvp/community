import '../../../../core/services/storage_service.dart';
import '../models/redemption_model.dart';
import '../models/user_details_model.dart';

abstract class RedemptionLocalDataSource {
  Future<void> cacheWalletTransactions(RedemptionModel transactions);
  Future<RedemptionModel?> getCachedWalletTransactions();
  Future<void> cacheUserDetails(UserDetailsModel userDetails);
  Future<UserDetailsModel?> getCachedUserDetails();
  Future<void> clearCache();
}

class RedemptionLocalDataSourceImpl implements RedemptionLocalDataSource {
  static const String _walletTransactionsKey = 'cached_wallet_transactions';
  static const String _userDetailsKey = 'cached_user_details';

  @override
  Future<void> cacheWalletTransactions(RedemptionModel transactions) async {
    await StorageService.setCacheWithExpiry(
      _walletTransactionsKey,
      transactions.toJson(),
      expiry: const Duration(minutes: 15),
    );
  }

  @override
  Future<RedemptionModel?> getCachedWalletTransactions() async {
    final data = StorageService.getCacheIfValid(_walletTransactionsKey);
    if (data != null) {
      return RedemptionModel.fromJson(data);
    }
    return null;
  }

  @override
  Future<void> cacheUserDetails(UserDetailsModel userDetails) async {
    await StorageService.setCacheWithExpiry(
      _userDetailsKey,
      userDetails.toJson(),
      expiry: const Duration(hours: 1),
    );
  }

  @override
  Future<UserDetailsModel?> getCachedUserDetails() async {
    final data = StorageService.getCacheIfValid(_userDetailsKey);
    if (data != null) {
      return UserDetailsModel.fromJson(data);
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    await StorageService.remove(_walletTransactionsKey);
    await StorageService.remove(_userDetailsKey);
  }
}
