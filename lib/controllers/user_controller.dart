import 'package:baby_watcher/controllers/api_service.dart';
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
  String? connectionRole;
  String? connectionPhone;
  String? connectionEmail;
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
      if (userRole == Role.parent &&
          responseData['connection']['babySitterId'] != null) {
        connectionId = responseData['connection']['babySitterId']['id'];
        connectionName = responseData['connection']['babySitterId']['name'];
        connectionRole = responseData['connection']['babySitterId']['role'];
        connectionEmail = responseData['connection']['babySitterId']['email'];
        connectionPhone = responseData['connection']['babySitterId']['phone'];
      } else if (userRole == Role.babySitter &&
          responseData['connection']['parentId'] != null) {
        connectionId = responseData['connection']['parentId']['id'];
        connectionName = responseData['connection']['parentId']['name'];
        connectionRole = responseData['connection']['parentId']['role'];
        connectionEmail = responseData['connection']['parentId']['email'];
        connectionPhone = responseData['connection']['parentId']['phone'];
      }
      print("""ID: $connectionId
      Name: $connectionName
      Phone: $connectionPhone
      Role: $connectionRole
      Email: $connectionEmail
""");
    }
    if (responseData['image'] != null) {
      image = responseData['image'];
    }
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
}
