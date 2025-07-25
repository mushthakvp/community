import '../../../../../core/error/exceptions.dart';
import '../../../core/constants/cook_api_endpoints.dart';
import '../../../core/network/cook_api_client.dart';
import '../../domain/entities/prize_overview.dart';
import '../models/prize_overview_model.dart';

abstract class PrizeOverviewRemoteDataSource {
  Future<PrizeOverview> getPrizeOverview(String challengeId);
}

class PrizeOverviewRemoteDataSourceImpl
    implements PrizeOverviewRemoteDataSource {
  final CookApiClient apiClient;

  PrizeOverviewRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PrizeOverview> getPrizeOverview(String challengeId) async {
    final params = <String, String>{'_id': challengeId};

    final result = await apiClient.get(
      CookApiEndpoints.getPrizeOverview,
      queryParameters: params,
    );

    return result.fold(
      (failure) => throw ServerException(failure.message),
      (data) => PrizeOverviewModel.fromJson(data),
    );
  }
}
