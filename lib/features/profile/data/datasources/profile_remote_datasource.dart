import 'dart:convert';
import 'dart:io';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/loyalty_card_model.dart';
import '../models/point_transaction_model.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String dialCode,
    String? profileImageUrl,
  });
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });
  Future<LoyaltyCardModel> getLoyaltyCard();
  Future<void> claimLoyaltyPoints();
  Future<List<PointTransactionModel>> getLoyaltyPointTransactions({
    required String status,
    required int page,
  });
  Future<void> optOut(String content);
  Future<String> uploadProfileImage(File imageFile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient client;

  ProfileRemoteDataSourceImpl({required this.client});

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await client.get(ApiConstants.getProfile);
      final data = json.decode(response.body);

      if (data['success'] == true && data['userDetails'] != null) {
        return ProfileModel.fromJson(data['userDetails']);
      } else {
        throw const ServerException('Failed to get profile');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error getting profile: $e');
    }
  }

  @override
  Future<ProfileModel> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String dialCode,
    String? profileImageUrl,
  }) async {
    try {
      final body = {
        'name': name,
        'email': email,
        'phone': phone,
        'dialCode': dialCode,
        if (profileImageUrl != null) 'profileImage': profileImageUrl,
      };
      final response = await client.post(
        ApiConstants.updateProfile,
        body: body,
      );
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return await getProfile();
      } else {
        throw ServerException(data['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error updating profile: $e');
    }
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final body = {'oldPassword': oldPassword, 'newPassword': newPassword};
      final response = await client.post(
        ApiConstants.changePassword,
        body: body,
      );
      final data = json.decode(response.body);

      if (data['success'] != true) {
        throw ServerException(data['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error changing password: $e');
    }
  }

  @override
  Future<LoyaltyCardModel> getLoyaltyCard() async {
    try {
      final response = await client.get(ApiConstants.getLoyaltyCard);
      final data = json.decode(response.body);

      if (data['success'] == true && data['card'] != null) {
        return LoyaltyCardModel.fromJson(data['card']);
      } else {
        throw const ServerException('Failed to get loyalty card');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error getting loyalty card: $e');
    }
  }

  @override
  Future<void> claimLoyaltyPoints() async {
    try {
      final response = await client.get(ApiConstants.claimLoyaltyPoints);
      final data = json.decode(response.body);

      if (data['success'] != true) {
        throw ServerException(
          data['message'] ?? 'Failed to claim loyalty points',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error claiming loyalty points: $e');
    }
  }

  @override
  Future<List<PointTransactionModel>> getLoyaltyPointTransactions({
    required String status,
    required int page,
  }) async {
    try {
      final response = await client.get(
        ApiConstants.loyaltyPointHistory,
        queryParameters: {'status': status, 'page': page.toString()},
      );
      final data = json.decode(response.body);

      if (data['success'] == true && data['pointHistory'] != null) {
        final List<dynamic> pointHistoryJson = data['pointHistory'];
        return pointHistoryJson
            .map((json) => PointTransactionModel.fromJson(json))
            .toList();
      } else {
        throw const ServerException('Failed to get point transactions');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error getting point transactions: $e');
    }
  }

  @override
  Future<void> optOut(String content) async {
    try {
      final body = {'content': content};

      final response = await client.post(ApiConstants.optOut, body: body);
      final data = json.decode(response.body);

      if (data['success'] != true) {
        throw ServerException(data['message'] ?? 'Failed to opt out');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error opting out: $e');
    }
  }

  @override
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      throw const ServerException('Image upload not implemented');
    } catch (e) {
      throw ServerException('Error uploading image: $e');
    }
  }
}
