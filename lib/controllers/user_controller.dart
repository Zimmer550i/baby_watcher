import 'package:baby_watcher/controllers/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

enum Role { notSelected, parent, babySitter }

class UserController extends GetxController {
  final api = Get.find<ApiService>();
  String userId = '';
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String? image;
  String? connectionId;
  String? connectionName;
  String? connectionImage;
  String? connectionPhone;
  String? connectionEmail;
  String? uniqueKey;
  String? packageName;
  bool isVerified = false;

  Role userRole = Role.notSelected;

  void setUserData(Map<String, dynamic> responseData) {
    userId = responseData['user']['_id'];
    userName = responseData['user']['name'];
    userEmail = responseData['user']['email'];
    userPhone = responseData['user']['phone'];
    isVerified = responseData['user']['verified'];

    switch (responseData['user']['role']) {
      case 'PARENT':
        userRole = Role.parent;
        break;
      case 'BABY_SITTER':
        userRole = Role.babySitter;
        break;
      default:
        userRole = Role.notSelected;
    }

    if (responseData['connection'] != null) {
      if (userRole == Role.parent &&
          responseData['connection']['babySitterId'] != null) {
        connectionId = responseData['connection']['babySitterId']['_id'];
        connectionName = responseData['connection']['babySitterId']['name'];
        connectionEmail = responseData['connection']['babySitterId']['email'];
        connectionPhone = responseData['connection']['babySitterId']['phone'];
        connectionImage = responseData['connection']['babySitterId']['image'];
      } else if (userRole == Role.babySitter &&
          responseData['connection']['parentId'] != null) {
        connectionId = responseData['connection']['parentId']['_id'];
        connectionName = responseData['connection']['parentId']['name'];
        connectionEmail = responseData['connection']['parentId']['email'];
        connectionPhone = responseData['connection']['parentId']['phone'];
        connectionImage = responseData['connection']['babySitterId']['image'];
      }
      debugPrint("""
      Connection Info =>
      ID: $connectionId
      Name: $connectionName
      Phone: $connectionPhone
      Image: $connectionImage
      Email: $connectionEmail
""");
    }
    image = responseData['user']['image'];
    uniqueKey = responseData['connection']['uniqueKey'];
    getSub();
  }

  void setConnectionId(String id) {
    connectionId = id;
  }

  String? getImageUrl() {
    final api = Get.find<ApiService>();

    if (image != null) {
      var s = api.baseUrl + image!;
      return s.replaceAll("/api/v1", "");
    } else {
      return null;
    }
  }

  Future<String> updateInfo(Map<String, dynamic> data) async {
    final response = await api.updateRequest(
      "/user/update-profile",
      data,
      isMultiPart: true,
      authRequired: true,
    );

    if (response == null) {
      return "No response from API";
    }
    if (response["success"] == true) {
      return "Success";
    } else {
      return response["message"] ?? "Unknown Error";
    }
  }

  Future<String> getInfo() async {
    final response = await api.getRequest('/user/profile', authRequired: true);

    if (response == null) {
      return "No response from API";
    }
    if (response['success'] == true) {
      Map<String, dynamic> user = response['data'];

      setUserData(user);

      return "Success";
    } else {
      return response['message'] ?? "Unknown error";
    }
  }

  Future<void> getSub() async {
    final response = await api.getRequest(
      "/subscription/get-subscription",
      authRequired: true,
    );

    if (response == null) {
      return;
    }
    if (response['success'] == true) {
      packageName = response['data']['isSubscription']['packageName'];
    }
  }
}
