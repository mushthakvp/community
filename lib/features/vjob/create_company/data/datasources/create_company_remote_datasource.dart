import 'dart:convert';
import 'dart:io';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/services/cloudinary_service.dart';
import '../models/company_model.dart';

abstract class CreateCompanyRemoteDataSource {
  Future<CompanyModel> createCompany(CompanyModel company);
  Future<CompanyModel> updateCompany(CompanyModel company);
  Future<String> uploadImage(String filePath);
}

class CreateCompanyRemoteDataSourceImpl
    implements CreateCompanyRemoteDataSource {
  final ApiClient apiClient;

  CreateCompanyRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CompanyModel> createCompany(CompanyModel company) async {
    try {
      final response = await apiClient.post(
        '/api/company/create-or-update',
        body: company.toCreateJson(),
      );

      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseModel = CreateCompanyResponse.fromJson(data);
        if (responseModel.company != null) {
          return responseModel.company!;
        }
        throw ServerException('Company data not found in response');
      } else {
        throw ServerException(data['message'] ?? 'Failed to create company');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to create company: $e');
    }
  }

  @override
  Future<CompanyModel> updateCompany(CompanyModel company) async {
    try {
      final response = await apiClient.post(
        '/api/company/create-or-update',
        body: company.toUpdateJson(),
      );

      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseModel = CreateCompanyResponse.fromJson(data);
        if (responseModel.company != null) {
          return responseModel.company!;
        }
        throw ServerException('Company data not found in response');
      } else {
        throw ServerException(data['message'] ?? 'Failed to update company');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to update company: $e');
    }
  }

  @override
  Future<String> uploadImage(String filePath) async {
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        throw ServerException('File does not exist');
      }
      String? url = await CloudinaryService.uploadSingleImage(file: file);
      return url ?? '';
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to upload image: $e');
    }
  }
}
