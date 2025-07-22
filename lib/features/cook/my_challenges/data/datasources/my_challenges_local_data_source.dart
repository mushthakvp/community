import 'dart:convert';

import '../../../../../core/services/storage_service.dart';
import '../../../core/constants/cook_constants.dart';
import '../../domain/entities/my_challenge.dart';
import '../models/my_challenge_model.dart';

abstract class MyChallengesLocalDataSource {
  Future<List<MyChallenge>?> getCachedMyChallenges(String status);
  Future<void> cacheMyChallenges(String status, List<MyChallenge> challenges);
  Future<void> clearMyChallengesCache();
}

class MyChallengesLocalDataSourceImpl implements MyChallengesLocalDataSource {
  @override
  Future<List<MyChallenge>?> getCachedMyChallenges(String status) async {
    try {
      final key = '${CookConstants.myChallengesCacheKey}_$status';
      final jsonString = StorageService.getString(key);
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as List;
        return json.map((item) => MyChallengeModel.fromJson(item)).toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheMyChallenges(
    String status,
    List<MyChallenge> challenges,
  ) async {
    try {
      final key = '${CookConstants.myChallengesCacheKey}_$status';
      final models = challenges
          .map((challenge) => MyChallengeModel.fromEntity(challenge).toJson())
          .toList();

      final jsonString = jsonEncode(models);
      await StorageService.setString(key, jsonString);
    } catch (e) {
      // Ignore cache errors
    }
  }

  @override
  Future<void> clearMyChallengesCache() async {
    try {
      await StorageService.remove(
        '${CookConstants.myChallengesCacheKey}_active',
      );
      await StorageService.remove(
        '${CookConstants.myChallengesCacheKey}_completed',
      );
    } catch (e) {
      // Ignore cache errors
    }
  }
}
