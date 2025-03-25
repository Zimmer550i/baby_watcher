import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:baby_watcher/controllers/user_controller.dart';
import 'token_service.dart';
import 'api_service.dart';

class AuthController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final UserController userController = Get.find<UserController>();

  var isLoggedIn = false.obs;
  var userInfo = {}.obs;

  Future<String> login(String email, String password) async {
    final response = await apiService.postRequest('/auth/login', {
      'email': email,
      'password': password,
    });

    if (response == null) {
      return "No response from API";
    }
    if (response['success'] == true) {
      final data = response['data'];

      String accessToken = data['accessToken'];
      String refreshToken = data['refreshToken'];

      await TokenService.saveTokens(accessToken, refreshToken);

      userInfo.value = data;
      userController.setUserData(data);
      isLoggedIn.value = true;

      return "Success";
    } else {
      return response['message'] ?? "Unknown error";
    }
  }

  Future<String> getUserInfo() async {
    final response = await apiService.getRequest(
      '/user/profile',
      authRequired: true,
    );

    if (response == null) {
      return "No response from API";
    }
    if (response['success'] == true) {
      Map<String, dynamic> user = response['data'];

      userInfo.value = user;
      userController.setUserData(user);
      isLoggedIn.value = true;

      return "Success";
    } else {
      return response['message'] ?? "Unknown error";
    }
  }

  Future<String> forgotPassword(String email) async {
    final response = await apiService.postRequest("/auth/forgot-password", {
      'email': email,
    });

    if (response == null) {
      return "No response from API";
    }
    if (response['success'] == true) {
      return "Success";
    } else {
      return response["message"] ?? "Unknown error";
    }
  }

  Future<String> resetPassword(String first, String second, String data) async {
    final response = await apiService.postRequest(
      "/auth/reset-password",
      {'newPassword': first, 'confirmPassword': second},
      customHeaders: {"Authorization": data},
    );

    if (response == null) {
      return "No response from API";
    }
    if (response['success'] == true) {
      return "Success";
    } else {
      return response["message"] ?? "Unknown error";
    }
  }

  Future<String> signup(Map<String, String> data) async {
    late Map<String, dynamic>? response;
    final role = userController.userRole;

    if (role == Role.babySitter) {
      response = await apiService.postRequest("/user/create-baby-sitter", data);
    } else if (role == Role.parent) {
      response = await apiService.postRequest("/user/create-parent", data);
    } else {
      return "Role selection process did not work";
    }

    if (response == null) {
      return "No response from API";
    }
    if (response['success'] == true) {
      return "Success";
    } else {
      return response['message'] ?? 'Unknown error';
    }
  }

  Future<bool> sendOtp() async {
    final email = userController.userEmail;
    final response = await apiService.postRequest("/auth/resend-otp", {
      "email": email,
    });

    if (response == null) {
      return false;
    }
    if (response['success'] == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> verifyEmail(
    String code, {
    bool isResetingPassword = false,
  }) async {
    final email = userController.userEmail;
    final response = await apiService.postRequest("/auth/verify-email", {
      "email": email,
      "oneTimeCode": int.parse(code),
    });

    if (response == null) {
      return "No response from API";
    }
    if (response['success'] == true) {
      final data = response['data'];

      String accessToken = data['accessToken'];
      String refreshToken = data['refreshToken'];

      await TokenService.saveTokens(accessToken, refreshToken);

      Map<String, dynamic> user = data['user'];
      Map<String, dynamic>? connection = data['connection'];

      user['connection'] = connection;
      userInfo.value = user;
      userController.setUserData(user);
      isLoggedIn.value = true;

      if (isResetingPassword) {
        return 'Success:${data['data']}';
      }

      return "Success";
    } else {
      return response["message"] ?? "Unknown error";
    }
  }

  Future<bool> checkLoginStatus() async {
    String? token = await TokenService.getAccessToken();
    if (token != null) {
      debugPrint('🔍 Token found. Fetching user info...');
      await getUserInfo();
      return true;
    } else {
      isLoggedIn.value = false;
      return false;
    }
  }

  Future<void> logout() async {
    await TokenService.clearTokens();
    userInfo.value = {};
    isLoggedIn.value = false;
  }
}
