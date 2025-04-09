import 'package:baby_watcher/controllers/api_service.dart';
import 'package:baby_watcher/controllers/socket_controller.dart';
import 'package:baby_watcher/controllers/user_controller.dart';
import 'package:baby_watcher/views/screen/common/messages.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  String? inboxId;
  final user = Get.find<UserController>();
  final api = Get.find<ApiService>();
  RxList<Message> messages = <Message>[].obs;
  var unreadMessages = 0.obs;
  RxBool isLoading = false.obs;

  void initialize() {
    final socket = Get.find<SocketController>();
    if (socket.socket!.disconnected) {
      socket.initialize();
    }
    if (inboxId == null) {
      fetchOrCreateInbox();
    }
  }

  Future<void> fetchOrCreateInbox() async {
    try {
      isLoading.value = true;
      final response = await api.getRequest(
        "/inbox/get-inbox",
        authRequired: true,
      );

      if (response != null && response["success"] == true) {
        List<dynamic> inboxList = response['data']['data'];

        for (var inbox in inboxList) {
          if (inbox['receiverId'] == user.connectionId.value) {
            inboxId = inbox['inboxId'];
            unreadMessages.value = inbox['unreadCount'];
            break;
          }
        }

        if (inboxId == null) {
          await createInbox();
        }

        await getPrevMessage();
      }
    } catch (e) {
      debugPrint('Error fetching inbox: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createInbox() async {
    try {
      final response = await api.postRequest(
        "/inbox/send-message/${user.connectionId.value}",
        {},
        authRequired: true,
      );

      if (response != null && response["success"] == true) {
        inboxId = response['data']['_id'];
      }
    } catch (e) {
      debugPrint('Error creating inbox: $e');
    }
  }

  void sendMessage(String text) {
    if (inboxId != null) {
      Get.find<SocketController>().socket!.emit('send-message', {
        'inboxId': inboxId,
        'message': text,
        'senderId': user.userId,
      });
    }
  }

  Future<void> getPrevMessage() async {
    final response = await api.getRequest(
      "/message/get-message/$inboxId",
      authRequired: true,
    );

    List data = response!['data']['result'];

    messages.clear();

    for (int i = 0; i < data.length; i++) {
      final each = data[i];

      messages.add(
        Message(
          text: each['message'],
          timeStamp: DateTime.parse(each['createdAt']),
          isSent: user.userId == each['senderId'],
        ),
      );
    }
    messages.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
  }

  void messageSeen() async {
    unreadMessages.value = 0;
  }
}
