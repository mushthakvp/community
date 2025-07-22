import 'dart:convert';

import '../../../../../core/services/storage_service.dart';
import '../../../core/constants/cook_constants.dart';
import '../../domain/entities/cooking_home.dart';
import '../models/cooking_home_model.dart';

abstract class HomeLocalDataSource {
  Future<CookingHome?> getCachedCookingHome();
  Future<void> cacheCookingHome(CookingHome cookingHome);
  Future<void> clearHomeCache();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  static const String _cacheKey = '${CookConstants.homeCacheKey}_v1';

  @override
  Future<CookingHome?> getCachedCookingHome() async {
    try {
      final jsonString = StorageService.getString(_cacheKey);
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        return CookingHomeModel.fromJson(json);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheCookingHome(CookingHome cookingHome) async {
    try {
      final model = CookingHomeModel(
        message: cookingHome.message,
        currentChallenges: cookingHome.currentChallenges,
        upcomingChallenges: cookingHome.upcomingChallenges,
        totalCurrentPages: cookingHome.totalCurrentPages,
        totalUpcomingPages: cookingHome.totalUpcomingPages,
        totalCurrentChallenges: cookingHome.totalCurrentChallenges,
        totalUpcomingChallenges: cookingHome.totalUpcomingChallenges,
      );

      final jsonString = jsonEncode(model.toJson());
      await StorageService.setString(_cacheKey, jsonString);
    } catch (e) {
      // Ignore cache errors
    }
  }

  @override
  Future<void> clearHomeCache() async {
    try {
      await StorageService.remove(_cacheKey);
    } catch (e) {
      // Ignore cache errors
    }
  }
}
