import 'package:baby_watcher/controllers/api_service.dart';
import 'package:baby_watcher/controllers/user_controller.dart';
import 'package:baby_watcher/models/log_model.dart';
import 'package:get/get.dart';

class LogController extends GetxController {
  final ApiService api = Get.find<ApiService>();
  var logs = [].obs;
  var selectedLog = Rxn<LogModel>();
  var isLoading = false.obs;

  Future<String> getLogs(DateTime date) async {
    isLoading.value = true;

    final response = await api.getRequest(
      Get.find<UserController>().userRole == Role.parent
          ? "/log/get-my-logs"
          : "/acceptLog/get",
      params: {"date": "${date.year}-${date.month}-${date.day}"},
      authRequired: true,
    );

    if (response == null) {
      isLoading.value = false;
      return "No response from API";
    }
    if (response["success"] == true) {
      var result = response['data']['result'];

      logs.clear();

      for (var e in result) {
        logs.add(LogModel.fromJson(e));
      }

      logs.sort((a, b) {
        return (a as LogModel).time.isAfter((b as LogModel).time) ? 1 : 0;
      });

      isLoading.value = false;
      return "Success";
    } else {
      isLoading.value = false;
      return response["message"] ?? "Unknown Error";
    }
  }

  Future<String> createLog(Map<String, dynamic> data) async {
    final response = await api.postRequest(
      "/log/create-log",
      data,
      authRequired: true,
    );

    if (response == null) {
      isLoading.value = false;
      return "No response from API";
    }
    if (response["success"] == true) {
      isLoading.value = false;
      return "Success";
    } else {
      isLoading.value = false;
      return response["message"] ?? "Unknown Error";
    }
  }

  Future<String> deleteLog(String logId) async {
    final response = await api.deleteRequest(
      "/log/delete/$logId/",
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

  Future<String> updateLog(LogModel log, bool sendTime) async {
    var data = log.toJson();
    if (!sendTime) {
      data.remove('time');
    }
    final response = await api.updateRequest(
      "/log/update/${log.id}",
      data,
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

  Future<String> acceptLog(LogModel log) async {
    final response = await api.updateRequest(
      "/acceptLog/accept/${log.id}",
      {},
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
}
