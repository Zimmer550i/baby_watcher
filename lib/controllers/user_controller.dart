import 'package:baby_watcher/controllers/api_service.dart';
import 'package:baby_watcher/utils/show_snackbar.dart';
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
  String? connectionTrackingId;
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
      connectionTrackingId = responseData['connection']['_id'];
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
      Tracking ID: $connectionTrackingId
      ID: $connectionId
      Name: $connectionName
      Phone: $connectionPhone
      Image: $connectionImage
      Email: $connectionEmail
""");
      uniqueKey = responseData['connection']['uniqueKey'];
    } else {
      if (userRole == Role.parent) {
        getUniqueKey();
      }
    }
    image = responseData['user']['image'];
    getSub();
  }

  void getUniqueKey() async {
    final response = await api.getRequest(
      "/unique-key/get-key",
      authRequired: true,
    );

    if (response != null && response['success'] == true) {
      uniqueKey = response['data']['uniqueKey'];
    } else {
      showSnackBar("Contact admin for an unique key");
      //TODO: no way to find out what's the response of no key
    }
  }

  Future<String> connectToMother(String key) async {
    final response = await api.postRequest("/connection/create", {
      'uniqueKey': key,
    }, authRequired: true);

    if (response == null) {
      return "No response from API";
    }
    if (response['success'] == true) {
      await getInfo();
      return "Success";
    } else {
      return response['message'] ?? "Unknown error";
    }
  }

  String? getImageUrl({bool forConn = false}) {
    if (image != null && !forConn) {
      var s = api.baseUrl + image!;
      return s.replaceAll("/api/v1", "");
    } else if (connectionImage != null && forConn) {
      var s = api.baseUrl + connectionImage!;
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

  Future<String> deleteConnection() async {
    final response = await api.deleteRequest(
      "/connection/delete/$connectionTrackingId",
      authRequired: true,
    );

    if (response == null) {
      return "No response from API";
    }
    if (response['success'] == true) {
      connectionId = null;
      connectionEmail = null;
      connectionImage = null;
      connectionName = null;
      connectionPhone = null;

      return "Success";
    } else {
      return response['message'] ?? "Unknown error";
    }
  }
}
