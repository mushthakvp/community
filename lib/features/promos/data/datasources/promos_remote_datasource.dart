import 'dart:convert';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/get_promos_model.dart';

abstract class PromosRemoteDataSource {
  Future<GetPromosModel> getPromos();
  Future<bool> addRewardPoints({required int points, required String action});
}

class PromosRemoteDataSourceImpl implements PromosRemoteDataSource {
  final ApiClient client;

  PromosRemoteDataSourceImpl({required this.client});

  @override
  Future<GetPromosModel> getPromos() async {
    try {
      final response = await client.get(ApiConstants.promosScreen);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = json.decode(response.body);
        return GetPromosModel.fromJson(jsonData);
      } else {
        throw ServerException('Failed to load promos: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<bool> addRewardPoints({
    required int points,
    required String action,
  }) async {
    try {
      final response = await client.post(
        ApiConstants.addRewardPointsFromPromos,
        body: {"points": points, "action": action},
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = json.decode(response.body);
        return jsonData['success'] == true;
      } else {
        throw ServerException(
          'Failed to add reward points: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: ${e.toString()}');
    }
  }
}
