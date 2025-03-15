import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'token_service.dart';

class ApiService extends GetxService {
  final String baseUrl = 'http://192.168.10.199:5002/api/v1';

  Future<Map<String, dynamic>?> getRequest(String endpoint, {bool authRequired = false}) async {
    try {
      final headers = await _getHeaders(authRequired);
      final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);

      if (response.statusCode == 401) {
        bool refreshed = await _refreshToken();
        if (refreshed) return getRequest(endpoint, authRequired: authRequired);
      }

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error in GET: $e');
      return null;
    }
  }
  Future<Map<String, dynamic>?> postRequest(String endpoint, dynamic data, {bool authRequired = false}) async {
    try {
      final headers = await _getHeaders(authRequired);
      final response = await http.post(Uri.parse('$baseUrl$endpoint'), headers: headers, body: jsonEncode(data));

      if (response.statusCode == 401) {
        bool refreshed = await _refreshToken();
        if (refreshed) return postRequest(endpoint, data, authRequired: authRequired);
      }

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error in POST: $e');
      return null;
    }
  }

  // No use for now 
  Future<bool> _refreshToken() async {
    try {
      String? refreshToken = await TokenService.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await TokenService.saveTokens(data['access_token'], data['refresh_token']);
        debugPrint('🔄 Token refreshed!');
        return true;
      } else {
        await TokenService.clearTokens();
        debugPrint('❌ Refresh token expired. User must log in again.');
        return false;
      }
    } catch (e) {
      debugPrint('Error refreshing token: $e');
      return false;
    }
  }

  Map<String, dynamic>? _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      debugPrint('API Error [${response.statusCode}]: ${response.body}');
      return null;
    }
  }

  // Retrieve Headers with Token
  Future<Map<String, String>> _getHeaders(bool authRequired) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    if (authRequired) {
      String? token = await TokenService.getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }
}