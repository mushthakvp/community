import '../../../../../core/error/exceptions.dart';
import '../../../core/constants/cook_api_endpoints.dart';
import '../../../core/network/cook_api_client.dart';

abstract class PreviewRemoteDataSource {
  Future<bool> submitTextRecipe({
    required String challengeId,
    required Map<String, dynamic> recipeData,
  });

  Future<bool> submitVideoRecipe({
    required String challengeId,
    required Map<String, dynamic> recipeData,
  });
}

class PreviewRemoteDataSourceImpl implements PreviewRemoteDataSource {
  final CookApiClient apiClient;

  PreviewRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<bool> submitTextRecipe({
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

  @override
  Future<bool> submitVideoRecipe({
    required String challengeId,
    required Map<String, dynamic> recipeData,
  }) async {
    final body = {'challengeId': challengeId, ...recipeData};
    final result = await apiClient.post(
      CookApiEndpoints.submitVideoRecipe,
      body: body,
    );
    return result.fold(
      (failure) => throw ServerException(failure.message),
      (data) => true,
    );
  }
}
