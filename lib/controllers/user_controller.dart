import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Role { notSelected, parent, babySitter }

class UserController extends GetxController {
  String userId = '';
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String? connectionId;
  bool isVerified = false;

  Role userRole = Role.notSelected;

  void setUserData(Map<String, dynamic> responseData) {
    userId = responseData['_id'];
    userName = responseData['name'];
    userEmail = responseData['email'];
    userPhone = responseData['phone'];
    isVerified = responseData['verified'];

    switch (responseData['role']) {
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
      connectionId = responseData['connection'].toString();
    }

    debugPrint('User data set: $userName, Role: $userRole');
  }

  void setConnectionId(String id) {
    connectionId = id;
  }
}
