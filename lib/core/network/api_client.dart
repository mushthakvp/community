import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../features/vcart/core/constants/vcart_constants.dart';
import '../constants/api_constants.dart';
import '../constants/chat_api_constants.dart';
import '../error/exceptions.dart';
import '../services/storage_service.dart';
import 'network_info.dart';

enum ApiClientType { main, chat, vcart }

class ApiClient {
  late http.Client _client;
  final String baseUrl;
  final NetworkInfo? networkInfo;
  final ApiClientType clientType;

  ApiClient({
    required this.baseUrl,
    this.networkInfo,
    required this.clientType,
  }) {
    _client = http.Client();
  }

  factory ApiClient.main({NetworkInfo? networkInfo}) {
    return ApiClient(
      baseUrl: ApiConstants.baseUrl,
      networkInfo: networkInfo,
      clientType: ApiClientType.main,
    );
  }

  factory ApiClient.chat({NetworkInfo? networkInfo}) {
    return ApiClient(
      baseUrl: ChatApiConstants.chatBaseUrl,
      networkInfo: networkInfo,
      clientType: ApiClientType.chat,
    );
  }

  factory ApiClient.vcart({NetworkInfo? networkInfo}) {
    return ApiClient(
      baseUrl: VCartConstants.baseUrl,
      networkInfo: networkInfo,
      clientType: ApiClientType.vcart,
    );
  }

  Future<Map<String, String>> _getHeaders({
    Map<String, String>? additionalHeaders,
  }) async {
    String? countryName = StorageService.getCountryName();

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = await StorageService.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (clientType == ApiClientType.main) {
      if (countryName != null) {
        headers['country'] = countryName;
      }
    }

    if (clientType == ApiClientType.chat) {
      if (countryName != null) {
        headers['country'] = countryName;
      }
      headers['Client-Type'] = 'chat';
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
    Map<String, dynamic>? body,
  }) async {
    try {
      await _checkConnectivity();

      final uri = _buildUri(endpoint);
      final requestHeaders = await _getHeaders(additionalHeaders: headers);

      final response = await _client
          .delete(
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

  String get clientInfo => 'ApiClient(type: $clientType, baseUrl: $baseUrl)';
}
