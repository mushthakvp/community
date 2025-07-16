import '../../../../core/error/error_handler.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/loyalty_card_entity.dart';
import '../../domain/entities/point_transaction_entity.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<ProfileEntity>> getProfile() async {
    try {
      final cachedProfile = await localDataSource.getCachedProfile();
      if (cachedProfile != null) {
        _fetchAndCacheProfile();
        return Success(cachedProfile.toEntity());
      }
      final profile = await remoteDataSource.getProfile();
      await localDataSource.cacheProfile(profile);
      return Success(profile.toEntity());
    } catch (e) {
      final failure = ErrorHandler.handleException(e as Exception);
      return Error(message: failure.message);
    }
  }

  Future<void> _fetchAndCacheProfile() async {
    try {
      final profile = await remoteDataSource.getProfile();
      await localDataSource.cacheProfile(profile);
    } catch (e) {
      // Ignore background fetch errors
    }
  }

  @override
  Future<Result<ProfileEntity>> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String dialCode,
    String? profileImageUrl,
  }) async {
    try {
      final updatedProfile = await remoteDataSource.updateProfile(
        name: name,
        email: email,
        phone: phone,
        dialCode: dialCode,
        profileImageUrl: profileImageUrl,
      );
      await localDataSource.cacheProfile(updatedProfile);
      return Success(updatedProfile.toEntity());
    } catch (e) {
      final failure = ErrorHandler.handleException(e as Exception);
      return Error(message: failure.message);
    }
  }

  @override
  Future<Result<void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return const Success(null);
    } catch (e) {
      final failure = ErrorHandler.handleException(e as Exception);
      return Error(message: failure.message);
    }
  }

  @override
  Future<Result<LoyaltyCardEntity>> getLoyaltyCard() async {
    try {
      final cachedCard = await localDataSource.getCachedLoyaltyCard();
      if (cachedCard != null) {
        _fetchAndCacheLoyaltyCard();
        return Success(cachedCard.toEntity());
      }
      final card = await remoteDataSource.getLoyaltyCard();
      await localDataSource.cacheLoyaltyCard(card);
      return Success(card.toEntity());
    } catch (e) {
      final failure = ErrorHandler.handleException(e as Exception);
      return Error(message: failure.message);
    }
  }

  Future<void> _fetchAndCacheLoyaltyCard() async {
    try {
      final card = await remoteDataSource.getLoyaltyCard();
      await localDataSource.cacheLoyaltyCard(card);
    } catch (e) {
      // Ignore background fetch errors
    }
  }

  @override
  Future<Result<void>> claimLoyaltyPoints() async {
    try {
      await remoteDataSource.claimLoyaltyPoints();
      // Clear cache to force refresh
      await localDataSource.clearCache();
      return const Success(null);
    } catch (e) {
      final failure = ErrorHandler.handleException(e as Exception);
      return Error(message: failure.message);
    }
  }

  @override
  Future<Result<List<PointTransactionEntity>>> getLoyaltyPointTransactions({
    required String status,
    required int page,
  }) async {
    try {
      final transactions = await remoteDataSource.getLoyaltyPointTransactions(
        status: status,
        page: page,
      );
      return Success(transactions.map((model) => model.toEntity()).toList());
    } catch (e) {
      final failure = ErrorHandler.handleException(e as Exception);
      return Error(message: failure.message);
    }
  }

  @override
  Future<Result<void>> optOut(String content) async {
    try {
      await remoteDataSource.optOut(content);
      return const Success(null);
    } catch (e) {
      final failure = ErrorHandler.handleException(e as Exception);
      return Error(message: failure.message);
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      throw UnimplementedError('Delete account not implemented yet');
    } catch (e) {
      final failure = ErrorHandler.handleException(e as Exception);
      return Error(message: failure.message);
    }
  }
}
