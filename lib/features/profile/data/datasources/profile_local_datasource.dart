import '../../../../core/services/storage_service.dart';
import '../models/loyalty_card_model.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel?> getCachedProfile();
  Future<void> cacheProfile(ProfileModel profile);
  Future<LoyaltyCardModel?> getCachedLoyaltyCard();
  Future<void> cacheLoyaltyCard(LoyaltyCardModel card);
  Future<void> clearCache();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  static const String _profileCacheKey = 'cached_profile';
  static const String _loyaltyCardCacheKey = 'cached_loyalty_card';

  @override
  Future<ProfileModel?> getCachedProfile() async {
    try {
      final cachedData = StorageService.getCacheIfValid(_profileCacheKey);
      if (cachedData != null) {
        return ProfileModel.fromJson(cachedData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheProfile(ProfileModel profile) async {
    try {
      await StorageService.setCacheWithExpiry(
        _profileCacheKey,
        profile.toJson(),
        expiry: const Duration(hours: 24),
      );
    } catch (e) {
      // Ignore cache errors
    }
  }

  @override
  Future<LoyaltyCardModel?> getCachedLoyaltyCard() async {
    try {
      final cachedData = StorageService.getCacheIfValid(_loyaltyCardCacheKey);
      if (cachedData != null) {
        return LoyaltyCardModel.fromJson(cachedData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheLoyaltyCard(LoyaltyCardModel card) async {
    try {
      await StorageService.setCacheWithExpiry(
        _loyaltyCardCacheKey,
        card.toJson(),
        expiry: const Duration(hours: 24),
      );
    } catch (e) {
      // Ignore cache errors
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.remove(_profileCacheKey);
      await StorageService.remove(_loyaltyCardCacheKey);
    } catch (e) {
      // Ignore cache errors
    }
  }
}
