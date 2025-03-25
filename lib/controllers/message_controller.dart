import 'package:baby_watcher/controllers/api_service.dart';
import 'package:baby_watcher/controllers/user_controller.dart';
import 'package:baby_watcher/views/screen/common/messages.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessageController extends GetxController {
  IO.Socket? socket;
  String? inboxId;
  final user = Get.find<UserController>();
  final api = Get.find<ApiService>();
  RxList<Message> messages = <Message>[].obs;
  RxBool isLoading = false.obs;

  void initialize() {
    _initializeSocket();
  }

  void _initializeSocket() {
    socket = IO.io(
      api.baseUrl.replaceAll("/api/v1", ""),
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000) 
          .build(),
    );

    socket?.onConnect((_) async {
      debugPrint("Connected to Socket.IO");
      await _fetchOrCreateInbox();

      socket!.on('receive-message:$inboxId', (data) {
        debugPrint(data.toString());
        messages.add(
          Message(
            text: data['message'],
            timeStamp: DateTime.parse(data['createdAt']),
            isSent: data['senderId'] == user.userId,
          ),
        );
      });
      debugPrint("Listening to receive-message:$inboxId");
    });

    socket?.onDisconnect((_) {
      debugPrint('Disconnected from Socket.IO server');
    });

    socket?.on('connect_error', (_) {
      debugPrint('Connection error, trying to reconnect...');
      socket?.connect();
    });

    socket?.on('connect_timeout', (_) {
      debugPrint('Connection timeout, trying to reconnect...');
      socket?.connect();
    });

    socket?.connect();
  }

  Future<void> _fetchOrCreateInbox() async {
    try {
      isLoading.value = true;
      final response = await api.getRequest(
        "/inbox/get-inbox",
        authRequired: true,
      );

      if (response != null && response["success"] == true) {
        List<dynamic> inboxList = response['data']['data'];

        for (var inbox in inboxList) {
          if (inbox['receiverId'] == user.connectionId) {
            inboxId = inbox['inboxId'];
            break;
          }
        }

        if (inboxId == null) {
          await _createInbox();
        }

        await getPrevMessage();
      }
    } catch (e) {
      debugPrint('Error fetching inbox: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _createInbox() async {
    try {
      final response = await api.postRequest(
        "/inbox/send-message/${user.connectionId}",
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
      socket!.emit('send-message', {
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
}
