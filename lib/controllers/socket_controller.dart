import 'package:baby_watcher/controllers/api_service.dart';
import 'package:baby_watcher/controllers/message_controller.dart';
import 'package:baby_watcher/controllers/user_controller.dart';
import 'package:baby_watcher/views/screen/common/messages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController extends GetxController {
  IO.Socket? socket;
  int page = 1;
  bool loadingNotifications = false;
  var unreadNotifications = 0.obs;
  bool reachedEnd = false;
  final api = Get.find<ApiService>();
  final user = Get.find<UserController>();
  final notifications = <DateTime, List<Map<String, dynamic>>>{}.obs;
  final messageController = Get.find<MessageController>();

  void initialize() {
    _initializeSocket();
    getPrevNotifications(page: page);
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
      await messageController.fetchOrCreateInbox();

      socket!.on('receive-message:${messageController.inboxId}', (data) {
        debugPrint(data.toString());
        messageController.messages.add(
          Message(
            text: data['message'],
            timeStamp: DateTime.parse(data['createdAt']),
            isSent: data['senderId'] == user.userId,
          ),
        );
      });

      socket!.on('get-notification:${user.userId}', (data) {
        print("GOT NOTIFICATION => ${data['text']}");
        final date = DateTime.parse(data['createdAt']);
        final dateKey = DateTime(
          date.year,
          date.month,
          date.day,
        ); // Format date for key
        if (notifications.containsKey(dateKey)) {
          notifications[dateKey]!.add(data); // Update to use dateKey
        } else {
          notifications[dateKey] = []; // Update to use dateKey
          notifications[dateKey]!.add(data); // Update to use dateKey
        }
      });
      debugPrint("Listening to receive-message:${messageController.inboxId}");
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

  void getPrevNotifications({int page = 1}) async {
    loadingNotifications = true;
    final response = await api.getRequest(
      "/notification/get-notification",
      params: {'limit': "10", 'page': page.toString()},
      authRequired: true,
    );

    if (response != null && response['success'] == true) {
      final result = response['data']['result'];
      final meta = response['data']['meta'];

      unreadNotifications.value = meta['unread'];

      if (result.length == 0) {
        reachedEnd = true;
      }

      for (int i = 0; i < result.length; i++) {
        final data = result[i];
        final date = DateTime.parse(data['createdAt']);
        final dateKey = DateTime(
          date.year,
          date.month,
          date.day,
        ); // Format date for key
        if (notifications.containsKey(dateKey)) {
          notifications[dateKey]!.add(data); // Update to use dateKey
        } else {
          notifications[dateKey] = []; // Update to use dateKey
          notifications[dateKey]!.add(data); // Update to use dateKey
        }
      }
    }

    loadingNotifications = false;
  }

  void getMoreNotification() {
    if (!reachedEnd && !loadingNotifications) {
      getPrevNotifications(page: ++page);
    }
  }

  void readNotifications() async {
    await api.updateRequest(
      "/notification/read-notification",
      {},
      authRequired: true,
    );
  }
}
