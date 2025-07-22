import '../../../../../core/error/exceptions.dart';
import '../../../core/constants/cook_api_endpoints.dart';
import '../../../core/network/cook_api_client.dart';
import '../../domain/entities/challenge_details.dart';
import '../models/challenge_details_model.dart';

abstract class ChallengeDetailsRemoteDataSource {
  Future<ChallengeDetails> getChallengeDetails(String challengeId);
  Future<bool> joinChallenge(String challengeId);
}

class ChallengeDetailsRemoteDataSourceImpl
    implements ChallengeDetailsRemoteDataSource {
  final CookApiClient apiClient;

  ChallengeDetailsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ChallengeDetails> getChallengeDetails(String challengeId) async {
    final params = <String, String>{'_id': challengeId};

    final result = await apiClient.get(
      CookApiEndpoints.challengeDetails,
      queryParameters: params,
    );

    return result.fold(
      (failure) => throw ServerException(failure.message),
      (data) => ChallengeDetailsModel.fromJson(data),
    );
  }

  @override
  Future<bool> joinChallenge(String challengeId) async {
    final body = {'_id': challengeId};

    final result = await apiClient.post(
      CookApiEndpoints.joinChallenge,
      body: body,
    );

    return result.fold(
      (failure) => throw ServerException(failure.message),
      (data) => true,
    );
  }
}
