import 'dart:developer';

import '../../../../../core/error/exceptions.dart';
import '../../../core/constants/cook_api_endpoints.dart';
import '../../../core/network/cook_api_client.dart';
import '../../domain/entities/cooking_home.dart';
import '../models/cooking_home_model.dart';

abstract class HomeRemoteDataSource {
  Future<CookingHome> getCookingHome({
    String? search,
    int currentPage = 1,
    int currentLimit = 3,
    int upcomingPage = 1,
    int upcomingLimit = 10,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final CookApiClient apiClient;

  HomeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CookingHome> getCookingHome({
    String? search,
    int currentPage = 1,
    int currentLimit = 3,
    int upcomingPage = 1,
    int upcomingLimit = 10,
  }) async {
    log('🌐 Fetching cooking home data...');
    final params = <String, String>{
      'currentPage': currentPage.toString(),
      'currentLimit': currentLimit.toString(),
      'upcomingPage': upcomingPage.toString(),
      'upcomingLimit': upcomingLimit.toString(),
    };

    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }

    final result = await apiClient.get(
      CookApiEndpoints.getHome,
      queryParameters: params,
    );

    return result.fold(
      (failure) => throw ServerException(failure.message),
      (data) => CookingHomeModel.fromJson(data),
    );
  }
}
