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
  RxnString connectionId = RxnString();
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
    uniqueKey = responseData['user']['uniqueKey'];

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
        connectionId.value = responseData['connection']['babySitterId']['_id'];
        connectionName = responseData['connection']['babySitterId']['name'];
        connectionEmail = responseData['connection']['babySitterId']['email'];
        connectionPhone = responseData['connection']['babySitterId']['phone'];
        connectionImage = responseData['connection']['babySitterId']['image'];
      } else if (userRole == Role.babySitter &&
          responseData['connection']['parentId'] != null) {
        connectionId.value = responseData['connection']['parentId']['_id'];
        connectionName = responseData['connection']['parentId']['name'];
        connectionEmail = responseData['connection']['parentId']['email'];
        connectionPhone = responseData['connection']['parentId']['phone'];
        connectionImage = responseData['connection']['parentId']['image'];
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
    } else {
      // if (userRole == Role.parent) {
      //   getUniqueKey();
      // }
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

  Future<String> subscribeDemo() async {
    Map<String, dynamic> data = {
      "productId": "com.example.premium",
      "purchaseId": "1234567890abcdef",
      "expiryDate": DateTime.now().add(Duration(days: 30)).toIso8601String(),
      "purchaseDate": DateTime.now().toIso8601String(),
      "packageName": "Premium Plan",
      "purchaseToken": "abcdef1234567890",
      "packagePrice": 4,
    };
    final response = await api.postRequest("/subscription/create", data, authRequired: true);

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
      connectionId.value = null;
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
