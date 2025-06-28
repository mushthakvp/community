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
    // Use the exact endpoint structure from the original code
    final filterType = filter == "Recharge" ? "Recharge" : filter;
    final from = fromDate ?? '';
    final to = toDate ?? '';

    // Build the URL like the original: getWalletTransactions?filter=All&from=&to=&page=1
    String endpoint = '${ApiConstants.getWalletTransactions}$filterType';

    final queryParams = <String, String>{
      if (from.isNotEmpty) 'from': from,
      if (to.isNotEmpty) 'to': to,
      'page': page.toString(),
    };

    final response = await client.get(endpoint, queryParameters: queryParams);

    final data = json.decode(response.body);
    return RedemptionModel.fromJson(data);
  }

  @override
  Future<UserDetailsModel> getUserRedemptionDetails() async {
    // Use the same endpoint as the original code
    final response = await client.get(
      'user/getHome',
    ); // This matches the original endpoint
    final data = json.decode(response.body);

    // Extract userDetails from the response like in the original
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
