// lib/core/network/api_client.dart

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../error/exceptions.dart';

class ApiClient {
  final http.Client client;
  final String baseUrl;
  final Duration timeout;

  ApiClient({
    required this.client,
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
  });

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await client
          .get(uri, headers: _buildHeaders(headers))
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('Network error occurred');
    } catch (e) {
      throw NetworkException('Unexpected network error: $e');
    }
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await client
          .post(
            uri,
            headers: _buildHeaders(headers),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('Network error occurred');
    } catch (e) {
      throw NetworkException('Unexpected network error: $e');
    }
  }

  Future<http.Response> put(
    String endpoint, {
    String? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await client
          .put(uri, headers: _buildHeaders(headers), body: body)
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('Network error occurred');
    } catch (e) {
      throw NetworkException('Unexpected network error: $e');
    }
  }

  Uri _buildUri(String endpoint, [Map<String, String>? queryParameters]) {
    final uri = Uri.parse('$baseUrl$endpoint');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: queryParameters);
    }
    return uri;
  }

  Map<String, String> _buildHeaders([Map<String, String>? additionalHeaders]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      String message = 'Client error';
      try {
        final data = json.decode(response.body);
        message = data['message'] ?? message;
      } catch (_) {}
      throw ServerException(message);
    } else if (response.statusCode >= 500) {
      throw const ServerException('Server error occurred');
    } else {
      throw ServerException('Unexpected status code: ${response.statusCode}');
    }
  }
}
