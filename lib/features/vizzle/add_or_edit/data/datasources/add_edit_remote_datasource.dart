import 'dart:convert';
import 'dart:io';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/ad_creation_model.dart';
import '../models/cities_response_model.dart';

abstract class AddEditRemoteDataSource {
  Future<CitiesResponseModel> getCitiesAndCategories();
  Future<List<String>> uploadImages(List<File> images);
  Future<String> createAd(AdCreationModel adModel);
  Future<String> updateAd(String adId, AdCreationModel adModel);
}

class AddEditRemoteDataSourceImpl implements AddEditRemoteDataSource {
  final ApiClient client;

  AddEditRemoteDataSourceImpl({required this.client});

  @override
  Future<CitiesResponseModel> getCitiesAndCategories() async {
    try {
      final response = await client.get(
        ApiConstants.getCitySectionAndCategories,
      );
      return CitiesResponseModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<String>> uploadImages(List<File> images) async {
    try {
      return [];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> createAd(AdCreationModel adModel) async {
    try {
      await client.post(ApiConstants.createAd, body: adModel.toJson());
      return "Ad created successfully";
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> updateAd(String adId, AdCreationModel adModel) async {
    try {
      await client.put('${ApiConstants.editAd}$adId', body: adModel.toJson());
      return "Ad updated successfully";
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
