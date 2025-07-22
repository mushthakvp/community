import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/storage_service.dart';
import '../constants/cook_constants.dart';

class CookApiClient {
  final http.Client client;
  final NetworkInfo networkInfo;

  CookApiClient({required this.client, required this.networkInfo});

  Future<Map<String, String>> _getHeaders() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = await StorageService.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<void> _checkConnectivity() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      throw const NetworkException('No internet connection available');
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> get(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    try {
      await _checkConnectivity();

      final uri = _buildUri(endpoint, queryParameters);
      final headers = await _getHeaders();

      final response = await client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      await _checkConnectivity();

      final uri = _buildUri(endpoint);
      final headers = await _getHeaders();

      final response = await client
          .post(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  Uri _buildUri(String endpoint, [Map<String, String>? queryParameters]) {
    final uri = Uri.parse('${CookConstants.baseUrl}$endpoint');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: queryParameters);
    }
    return uri;
  }

  Either<Failure, Map<String, dynamic>> _handleResponse(
    http.Response response,
  ) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Right(data);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to parse response'));
      }
    } else {
      try {
        final data = json.decode(response.body);
        String message =
            data['message'] ?? data['error'] ?? data['msg'] ?? 'Request failed';
        return Left(ServerFailure(message: message));
      } catch (e) {
        return Left(
          ServerFailure(
            message: 'Request failed with status ${response.statusCode}',
          ),
        );
      }
    }
  }
}
