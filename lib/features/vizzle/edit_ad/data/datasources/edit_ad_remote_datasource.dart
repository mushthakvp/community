import 'dart:convert';
import 'dart:io';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/services/cloudinary_service.dart';
import '../../../profile/data/models/advertisement_model.dart';
import '../models/edit_ad_request_model.dart';
import '../models/edit_ad_response_model.dart';

abstract class EditAdRemoteDataSource {
  Future<AdvertisementModel> getAdDetails(String adId);
  Future<EditAdResponseModel> editAd(EditAdRequestModel request);
  Future<List<String>> uploadImages(List<String> imagePaths);
}

class EditAdRemoteDataSourceImpl implements EditAdRemoteDataSource {
  final ApiClient apiClient;

  EditAdRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AdvertisementModel> getAdDetails(String adId) async {
    try {
      final response = await apiClient.get('${ApiConstants.vizzleAds}/$adId');
      final data = jsonDecode(response.body);

      if (data['success'] == true || response.statusCode == 200) {
        return AdvertisementModel.fromJson(data['advertisement'] ?? data);
      } else {
        throw ServerException(data['message'] ?? 'Failed to fetch ad details');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<EditAdResponseModel> editAd(EditAdRequestModel request) async {
    try {
      final response = await apiClient.put(
        '${ApiConstants.vizzleEditAd}/${request.id}',
        body: request.toJson(),
      );
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return EditAdResponseModel.fromJson(data);
      } else {
        throw ServerException(data['message'] ?? 'Failed to edit ad');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> uploadImages(List<String> imagePaths) async {
    try {
      final files = imagePaths.map((path) => File(path)).toList();
      final uploadedUrls = await CloudinaryService.uploadImagesList(
        files: files,
        folder: 'vizzle_ads',
      );
      return uploadedUrls;
    } catch (e) {
      throw ServerException('Failed to upload images: ${e.toString()}');
    }
  }
}
