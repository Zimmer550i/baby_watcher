import 'package:baby_watcher/controllers/api_service.dart';
import 'package:get/get.dart';

class MonitorController extends GetxController {
  final api = Get.find<ApiService>();

  Future<String> sendRequest() async {
    final response = await api.postRequest(
      "/video-req/send-req",
      {},
      authRequired: true,
    );

    if (response != null && response["success"] == true) {
      return "Success";
    } else {
      return response?["message"] ?? "Unknown Error";
    }
  }
}
