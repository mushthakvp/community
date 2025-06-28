import '../../../../core/utils/result.dart';
import '../entities/loyalty_card_entity.dart';
import '../entities/point_transaction_entity.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Result<ProfileEntity>> getProfile();
  Future<Result<ProfileEntity>> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String dialCode,
    String? profileImageUrl,
  });
  Future<Result<void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  // Loyalty Points
  Future<Result<LoyaltyCardEntity>> getLoyaltyCard();
  Future<Result<void>> claimLoyaltyPoints();
  Future<Result<List<PointTransactionEntity>>> getLoyaltyPointTransactions({
    required String status,
    required int page,
  });

  // Account Management
  Future<Result<void>> optOut(String content);
  Future<Result<void>> deleteAccount();
}
