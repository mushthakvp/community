import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../error/exceptions.dart';
import '../services/storage_service.dart';
import 'network_info.dart';

class ApiClient {
  late http.Client _client;
  final String baseUrl;
  final NetworkInfo? networkInfo;

  ApiClient({required this.baseUrl, this.networkInfo}) {
    _client = http.Client();
  }

  Future<Map<String, String>> _getHeaders({
    Map<String, String>? additionalHeaders,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add auth token if available
    final token = await StorageService.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    // Add country header if available
    String? countryName = StorageService.getCountryName();
    if (countryName != null) {
      headers['country'] = countryName;
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  Future<void> _checkConnectivity() async {
    if (networkInfo != null) {
      final isConnected = await networkInfo!.isConnected;
      if (!isConnected) {
        throw const NetworkException('No internet connection available');
      }
    }
  }

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      await _checkConnectivity();

      final uri = _buildUri(endpoint, queryParameters);
      final requestHeaders = await _getHeaders(additionalHeaders: headers);

      final response = await _client
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: ApiConstants.timeoutDuration));

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('Network error occurred');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('$e');
    }
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      await _checkConnectivity();
      final uri = _buildUri(endpoint);
      final requestHeaders = await _getHeaders(additionalHeaders: headers);
      final response = await _client
          .post(
            uri,
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(Duration(seconds: ApiConstants.timeoutDuration));
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('Network error occurred');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('$e');
    }
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      await _checkConnectivity();

      final uri = _buildUri(endpoint);
      final requestHeaders = await _getHeaders(additionalHeaders: headers);

      final response = await _client
          .put(
            uri,
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(Duration(seconds: ApiConstants.timeoutDuration));

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('Network error occurred');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('$e');
    }
  }

  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      await _checkConnectivity();

      final uri = _buildUri(endpoint);
      final requestHeaders = await _getHeaders(additionalHeaders: headers);

      final response = await _client
          .delete(uri, headers: requestHeaders)
          .timeout(Duration(seconds: ApiConstants.timeoutDuration));

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('Network error occurred');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('$e');
    }
  }

  Uri _buildUri(String endpoint, [Map<String, String>? queryParameters]) {
    final uri = Uri.parse('$baseUrl$endpoint');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: queryParameters);
    }
    return uri;
  }

  http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      try {
        final data = json.decode(response.body);
        String message =
            data['message'] ?? data['error'] ?? data['msg'] ?? "Request failed";
        throw ServerException(message);
      } catch (e) {
        if (e is ServerException) rethrow;
        throw ServerException(
          "Request failed with status ${response.statusCode}",
        );
      }
    }
  }

  void dispose() {
    _client.close();
  }
}
