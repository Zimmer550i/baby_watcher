import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'token_service.dart';

class ApiService extends GetxService {
  final String baseUrl = 'http://192.168.10.199:5002/api/v1';

  Future<Map<String, dynamic>?> getRequest(
    String endpoint, {
    bool authRequired = false,  
    Map<String, String>? customHeaders,
    Map<String, String>? params,
  }) async {
    try {
      final headers = await _getHeaders(
        authRequired,
        customHeaders: customHeaders,
      );
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: params);
      final response = await http.get(uri, headers: headers);

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error in GET: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> postRequest(
    String endpoint,
    dynamic data, {
    bool authRequired = false,
    Map<String, String>? customHeaders,
    Map<String, String>? params,
  }) async {
    try {
      final headers = await _getHeaders(
        authRequired,
        customHeaders: customHeaders,
      );
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: params);
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error in POST: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteRequest(
    String endpoint, {
    bool authRequired = false,
    Map<String, String>? customHeaders,
    Map<String, String>? params,
  }) async {
    try {
      final headers = await _getHeaders(
        authRequired,
        customHeaders: customHeaders,
      );
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: params);
      final response = await http.delete(uri, headers: headers);

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error in DELETE: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateRequest(
    String endpoint,
    dynamic data, {
    bool authRequired = false,
    Map<String, String>? customHeaders,
    Map<String, String>? params,
  }) async {
    try {
      final headers = await _getHeaders(
        authRequired,
        customHeaders: customHeaders,
      );
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: params);
      final response = await http.patch(
        uri,
        headers: headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error in PUT: $e');
      return null;
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('API Called [${response.statusCode}]: ${response.body}');
      return jsonDecode(response.body);
    } else {
      debugPrint('API Error [${response.statusCode}]: ${response.body}');
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, String>> _getHeaders(
    bool authRequired, {
    Map<String, String>? customHeaders,
  }) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    if (authRequired) {
      String? token = await TokenService.getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }
}
