import '../../../../../core/error/exceptions.dart';
import '../../../core/constants/cook_api_endpoints.dart';
import '../../../core/network/cook_api_client.dart';
import '../../domain/entities/my_challenge.dart';
import '../models/my_challenge_model.dart';

abstract class MyChallengesRemoteDataSource {
  Future<List<MyChallenge>> getMyChallenges({
    required String status,
    int page = 1,
    int limit = 10,
  });

  Future<bool> joinChallenge(String challengeId);

  Future<bool> submitRecipe({
    required String challengeId,
    required Map<String, dynamic> recipeData,
  });
}

class MyChallengesRemoteDataSourceImpl implements MyChallengesRemoteDataSource {
  final CookApiClient apiClient;

  MyChallengesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<MyChallenge>> getMyChallenges({
    required String status,
    int page = 1,
    int limit = 10,
  }) async {
    final params = <String, String>{
      'status': status,
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final result = await apiClient.get(
      CookApiEndpoints.getMyChallenges,
      queryParameters: params,
    );

    return result.fold((failure) => throw ServerException(failure.message), (
      data,
    ) {
      final challenges = data['challenges'] as List? ?? [];
      return challenges.map((json) => MyChallengeModel.fromJson(json)).toList();
    });
  }

  @override
  Future<bool> joinChallenge(String challengeId) async {
    final result = await apiClient.post(
      CookApiEndpoints.joinChallenge,
      body: {'challengeId': challengeId},
    );

    return result.fold(
      (failure) => throw ServerException(failure.message),
      (data) => true,
    );
  }

  @override
  Future<bool> submitRecipe({
    required String challengeId,
    required Map<String, dynamic> recipeData,
  }) async {
    final body = {'challengeId': challengeId, ...recipeData};

    final result = await apiClient.post(
      CookApiEndpoints.submitTextRecipe,
      body: body,
    );

    return result.fold(
      (failure) => throw ServerException(failure.message),
      (data) => true,
    );
  }
}
