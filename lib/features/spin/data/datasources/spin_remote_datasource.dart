import 'dart:convert';
import 'dart:developer';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/spin_config_model.dart';
import '../models/spin_history_model.dart';
import '../models/spin_option_model.dart';
import '../models/spin_response_model.dart';
import '../models/spin_result_model.dart';

abstract class SpinRemoteDataSource {
  Future<SpinConfigModel> getSpinConfig(String spinType);
  Future<List<SpinOptionModel>> getSpinOptions(String spinType);
  Future<SpinResultModel> performSpin({
    required String optionId,
    required String spinType,
    bool isUnlimited = false,
  });
  Future<List<SpinHistoryModel>> getSpinHistory({
    int page = 1,
    int limit = 10,
    String? spinType,
  });
  Future<bool> canUserSpin(String spinType);
  Future<int> getRemainingSpins(String spinType);
  Future<int> getUserLoyaltyPoints();
}

class SpinRemoteDataSourceImpl implements SpinRemoteDataSource {
  final ApiClient apiClient;

  SpinRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SpinConfigModel> getSpinConfig(String spinType) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.getSpinAndEarnData}$spinType',
      );
      log("spin data ${response.body}");
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final spinResponse = SpinResponseModel.fromJson(responseData);

        if (spinResponse.success) {
          return SpinConfigModel.fromJson(spinResponse.data);
        } else {
          throw ServerException(spinResponse.message);
        }
      } else {
        throw ServerException(
          responseData['message'] ?? 'Failed to get spin config',
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SpinOptionModel>> getSpinOptions(String spinType) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.getSpinAndEarnData}$spinType',
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final spinResponse = SpinResponseModel.fromJson(responseData);

        if (spinResponse.success) {
          final data = spinResponse.data;
          final optionsData = data['data'] as List<dynamic>? ?? [];

          return optionsData
              .map((option) => SpinOptionModel.fromJson(option))
              .toList();
        } else {
          throw ServerException(spinResponse.message);
        }
      } else {
        throw ServerException(
          responseData['message'] ?? 'Failed to get spin options',
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<SpinResultModel> performSpin({
    required String optionId,
    required String spinType,
    bool isUnlimited = false,
  }) async {
    try {
      final body = {
        'spinOptionId': optionId,
        'spinType': spinType,
        'isUnlimited': isUnlimited,
      };

      final response = await apiClient.post(
        ApiConstants.userDialySpin,
        body: body,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final spinResponse = SpinResponseModel.fromJson(responseData);

        if (spinResponse.success) {
          return SpinResultModel.fromJson(spinResponse.data);
        } else {
          throw ServerException(spinResponse.message);
        }
      } else {
        throw ServerException(
          responseData['message'] ?? 'Failed to perform spin',
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SpinHistoryModel>> getSpinHistory({
    int page = 1,
    int limit = 10,
    String? spinType,
  }) async {
    try {
      final queryParams = {'page': page.toString(), 'limit': limit.toString()};

      if (spinType != null) {
        queryParams['spinType'] = spinType;
      }

      final response = await apiClient.get(
        ApiConstants.getSpinAndEarnHistory,
        queryParameters: queryParams,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final spinResponse = SpinResponseModel.fromJson(responseData);

        if (spinResponse.success) {
          final data = spinResponse.data;
          final historyData = data['data'] as List<dynamic>? ?? [];

          return historyData
              .map((history) => SpinHistoryModel.fromJson(history))
              .toList();
        } else {
          throw ServerException(spinResponse.message);
        }
      } else {
        throw ServerException(
          responseData['message'] ?? 'Failed to get spin history',
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> canUserSpin(String spinType) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.getSpinAndEarnData}$spinType',
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final spinResponse = SpinResponseModel.fromJson(responseData);

        if (spinResponse.success) {
          final data = spinResponse.data;
          return data['canSpin'] ?? false;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<int> getRemainingSpins(String spinType) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.getSpinAndEarnData}$spinType',
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final spinResponse = SpinResponseModel.fromJson(responseData);

        if (spinResponse.success) {
          final data = spinResponse.data;
          return data['remainingSpins'] ?? 0;
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<int> getUserLoyaltyPoints() async {
    try {
      final response = await apiClient.get(ApiConstants.userDetailsEndPoint);

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final spinResponse = SpinResponseModel.fromJson(responseData);

        if (spinResponse.success) {
          final data = spinResponse.data;
          return data['loyaltyPoints'] ?? 0;
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
