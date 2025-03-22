import 'package:baby_watcher/controllers/api_service.dart';
import 'package:baby_watcher/models/contact_model.dart';
import 'package:get/get.dart';

class EmergencyController extends GetxController {
  final api = Get.find<ApiService>();
  final contacts = <ContactModel>[].obs;
  RxList<String> alerts = <String>[].obs;
  List<String> alertsId = [];
  Rx<bool> isLoading = false.obs;

  Future<String> createContact(String name, String number) async {
    isLoading.value = true;
    final response = await api.postRequest("/emergancy-contact/create", {
      "name": name,
      "contact": number,
    }, authRequired: true);

    if (response == null) {
      isLoading.value = false;
      return "No response from API";
    } else if (response['success'] == true) {
      isLoading.value = false;
      return "Success";
    } else {
      isLoading.value = false;
      return response['message'] ?? "Unknown error";
    }
  }

  Future<String> updateContact(String id, Map<String, String> data) async {
    isLoading.value = true;
    final response = await api.updateRequest(
      "/emergancy-contact/update/$id",
      data,
      authRequired: true,
    );

    if (response == null) {
      isLoading.value = false;
      return "No response from API";
    } else if (response['success'] == true) {
      isLoading.value = false;
      return "Success";
    } else {
      isLoading.value = false;
      return response['message'] ?? "Unknown error";
    }
  }

  Future<String> deleteContact(String id) async {
    final response = await api.deleteRequest(
      "/emergancy-contact/delete/$id",
      authRequired: true,
    );

    if (response == null) {
      return "No response from API";
    } else if (response['success'] == true) {
      return "Success";
    } else {
      return response['message'] ?? "Unknown error";
    }
  }

  Future<String> getParentContact() async {
    isLoading.value = true;
    final response = await api.getRequest(
      "/emergancy-contact/get-my-contacts",
      authRequired: true,
    );

    if (response == null) {
      isLoading.value = false;
      return "No response from API";
    } else if (response['success'] == true) {
      final data = response['data'];

      contacts.clear();

      for (var i in data) {
        contacts.add(ContactModel(i['_id'], i['name'], i['contact']));
      }

      isLoading.value = false;
      return "Success";
    } else {
      isLoading.value = false;
      return response['message'] ?? "Unknown error";
    }
  }

  Future<String> getAlerts() async {
    final response = await api.getRequest(
      "/emergancy-alert/get-all",
      authRequired: true,
    );

    if (response == null) {
      return "No response from API";
    } else if (response['success'] == true) {
      final data = response['data'];

      alerts.clear();
      alertsId = [];

      for (var i in data) {
        alerts.add(i["message"]);
        alertsId.add(i['_id']);
      }

      return "Success";
    } else {
      isLoading.value = false;
      return response['message'] ?? "Unknown error";
    }
  }

  Future<String> deleteAlert(int index) async {
    final response = await api.deleteRequest(
      "/emergancy-alert/delete/${alertsId[index]}",
      authRequired: true,
    );

    if (response == null) {
      return "No response from API";
    } else if (response['success'] == true) {
      alertsId.removeAt(index);
      alerts.removeAt(index);
      return "Success";
    } else {
      return response['message'] ?? "Unknown error";
    }
  }
}
