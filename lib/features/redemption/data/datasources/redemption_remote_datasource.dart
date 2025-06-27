// lib/features/redemption/data/datasources/redemption_remote_datasource.dart
import 'dart:convert';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/redemption_model.dart';
import '../models/user_details_model.dart';
import '../models/wallet_recharge_model.dart';

abstract class RedemptionRemoteDataSource {
  Future<RedemptionModel> getWalletTransactions({
    String filter = 'All',
    String? fromDate,
    String? toDate,
    int page = 1,
  });

  Future<UserDetailsModel> getUserRedemptionDetails();

  Future<WalletRechargeModel> initiateWalletRecharge({required double amount});

  Future<WalletRechargeModel> initiateTierUpgrade();

  Future<Map<String, dynamic>> verifyPayment({
    required Map<String, dynamic> paymentDetails,
  });
}

class RedemptionRemoteDataSourceImpl implements RedemptionRemoteDataSource {
  final ApiClient client;

  RedemptionRemoteDataSourceImpl({required this.client});

  @override
  Future<RedemptionModel> getWalletTransactions({
    String filter = 'All',
    String? fromDate,
    String? toDate,
    int page = 1,
  }) async {
    final filterType = filter == "Recharge" ? "Recharge" : filter;
    final from = fromDate ?? '';
    final to = toDate ?? '';
    final queryParams = <String, String>{
      'type': filterType,
      if (from.isNotEmpty) 'from': from,
      if (to.isNotEmpty) 'to': to,
      'page': page.toString(),
    };
    final response = await client.get(
      ApiConstants.getWalletTransactions,
      queryParameters: queryParams,
    );
    final data = json.decode(response.body);

    return RedemptionModel.fromJson(data);
  }

  @override
  Future<UserDetailsModel> getUserRedemptionDetails() async {
    final response = await client.get(ApiConstants.profile);
    final data = json.decode(response.body);
    final userDetails = data['userDetails'] ?? data;
    return UserDetailsModel.fromJson(userDetails);
  }

  @override
  Future<WalletRechargeModel> initiateWalletRecharge({
    required double amount,
  }) async {
    final response = await client.post(
      ApiConstants.initiatePayment,
      body: {'amount': amount.toString()},
    );
    final data = json.decode(response.body);
    return WalletRechargeModel.fromJson(data);
  }

  @override
  Future<WalletRechargeModel> initiateTierUpgrade() async {
    final response = await client.get(ApiConstants.initiateTierUpgrade);
    final data = json.decode(response.body);

    return WalletRechargeModel.fromJson(data);
  }

  @override
  Future<Map<String, dynamic>> verifyPayment({
    required Map<String, dynamic> paymentDetails,
  }) async {
    final response = await client.post(
      ApiConstants.verifyPayment,
      body: {'paymentDetails': paymentDetails},
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }
}
