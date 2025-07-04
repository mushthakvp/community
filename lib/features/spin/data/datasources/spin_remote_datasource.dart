import 'dart:convert';
import 'dart:developer';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/spin_option_entity.dart';
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
          // Transform the API response to match SpinConfigModel structure
          final configData = {
            'id': spinType,
            'type': spinType,
            'maxSpinsPerDay': 1, // Default for daily spin
            'requiredPoints': responseData['requiredPoints'] ?? 0,
            'isActive': responseData['canSpin'] ?? true,
            'options': responseData['data'] ?? [], // The options array from API
            'spinDuration': 3,
            'soundEnabled': true,
            'hapticEnabled': true,
          };

          return SpinConfigModel.fromJson(configData);
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
          // The data is directly an array of options
          final optionsData = responseData['data'] as List<dynamic>? ?? [];

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

      log("Performing spin with body: ${json.encode(body)}");

      final response = await apiClient.post(
        ApiConstants.userDialySpin,
        body: body,
      );

      log("Spin response status: ${response.statusCode}");
      log("Spin response body: ${response.body}");

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final spinResponse = SpinResponseModel.fromJson(responseData);

        if (spinResponse.success) {
          log("Spin response data: ${spinResponse.data}");
          log("Spin response data type: ${spinResponse.data.runtimeType}");

          // Get the selected option from the original spin options
          final selectedOption = await _getSelectedOption(optionId, spinType);

          // Create the spin result
          if (spinResponse.data != null &&
              spinResponse.data is Map<String, dynamic>) {
            // Use the API response data
            final resultData = spinResponse.data as Map<String, dynamic>;
            // Ensure the spinOption is included
            if (resultData['spinOption'] == null ||
                (resultData['spinOption'] as Map).isEmpty) {
              resultData['spinOption'] = selectedOption.toJson();
            }
            return SpinResultModel.fromJson(resultData);
          } else {
            // Create result from selected option
            return SpinResultModel.fromSelectedOption(
              selectedOption: selectedOption,
              spinType: spinType,
              isSuccess: true,
            );
          }
        } else {
          throw ServerException(spinResponse.message);
        }
      } else {
        throw ServerException(
          responseData['message'] ?? 'Failed to perform spin',
        );
      }
    } catch (e) {
      log("Error in performSpin: $e");
      throw ServerException(e.toString());
    }
  }

  // Helper method to get the selected option
  Future<SpinOptionModel> _getSelectedOption(
    String optionId,
    String spinType,
  ) async {
    try {
      final options = await getSpinOptions(spinType);
      final selectedOption = options.firstWhere(
        (option) => option.id == optionId,
        orElse: () => options.first, // Fallback to first option
      );
      return selectedOption;
    } catch (e) {
      // If we can't get the option, create a default one
      return SpinOptionModel(
        id: optionId,
        title: 'Spin Result',
        description: 'Your spin result',
        rewardType: SpinRewardType.betterLuck,
      );
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
          return responseData['canSpin'] ?? false;
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
          // For daily spin, calculate remaining spins based on canSpin
          final canSpin = responseData['canSpin'] ?? false;
          return canSpin ? 1 : 0;
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
      // Try to get from user details endpoint first
      try {
        final response = await apiClient.get(ApiConstants.userDetailsEndPoint);
        final responseData = json.decode(response.body);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          final spinResponse = SpinResponseModel.fromJson(responseData);
          if (spinResponse.success) {
            final data = spinResponse.data;
            return data['loyaltyPoints'] ?? data['userLoyaltyPoints'] ?? 0;
          }
        }
      } catch (e) {
        // If user details endpoint fails, try to get from spin data
        log('Failed to get loyalty points from user details, trying spin data');
      }

      // Fallback: Get from spin data endpoint
      final response = await apiClient.get(
        '${ApiConstants.getSpinAndEarnData}daily_spin',
      );
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData['userLoyaltyPoints'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
