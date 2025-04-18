import 'package:baby_watcher/controllers/api_service.dart';
import 'package:baby_watcher/controllers/emergency_controller.dart';
import 'package:baby_watcher/controllers/log_controller.dart';
import 'package:baby_watcher/controllers/message_controller.dart';
import 'package:baby_watcher/controllers/monitor_controller.dart';
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
  final log = Get.find<LogController>();
  final emergency = Get.find<EmergencyController>();
  final monitor = Get.find<MonitorController>();
  final notifications = <DateTime, List<Map<String, dynamic>>>{}.obs;
  final messageController = Get.find<MessageController>();

  final callBackTriggers = [
    ["You have a new video request"],
    ["You have a new log", "Your log has been completed"],
    ["reported"],
    ["Your baby has been "],
    ["You have a new video"],
  ];
  List<Future Function()> callBackMethods = [];

  void initialize() {
    _initializeSocket();
    getPrevNotifications(page: page);

    callBackMethods = [
      () => monitor.getRequest(),
      () => log.getLogs(DateTime.now()),
      () => emergency.getAlerts(),
      () => monitor.getSleepData(),
      () => monitor.getVideos(n: 1),
    ];
  }

  void _initializeSocket() {
    socket = IO.io(
      api.baseUrl.replaceAll("/api/v1", ""),
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

    socket?.onConnect((_) async {
      debugPrint("Connected to Socket.IO");
      await messageController.fetchOrCreateInbox();

      socket!.off('receive-message:${messageController.inboxId}');
      socket!.on('receive-message:${messageController.inboxId}', (data) {
        debugPrint(data.toString());
        messageController.unreadMessages += 1;
        messageController.messages.add(
          Message(
            text: data['message'],
            timeStamp: DateTime.parse(data['createdAt']),
            isSent: data['senderId'] == user.userId,
          ),
        );
      });
      debugPrint("Listening to receive-message:${messageController.inboxId}");

      socket!.off('get-notification::${user.userId}');
      socket!.on('get-notification::${user.userId}', (data) {

        for (int i = 0; i < callBackTriggers.length; i++) {
          if (callBackTriggers[i].any(
            (trigger) =>
                data['text'].toLowerCase().contains(trigger.toLowerCase()),
          )) {
            callBackMethods[i]().then((val) {
            });
          }
        }

        final date = DateTime.parse(data['createdAt']);
        final dateKey = DateTime(
          date.year,
          date.month,
          date.day,
        ); // Format date for key
        notifications.update(
          dateKey,
          (list) {
            list.add(data);
            return list;
          },
          ifAbsent: () {
            return [data];
          },
        );
        sortNotifications();
        unreadNotifications += 1;
      });
      debugPrint("Listening to get-notification::${user.userId}");
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
        notifications.update(
          dateKey,
          (list) {
            list.add(data);
            return list;
          },
          ifAbsent: () {
            return [data];
          },
        );
        sortNotifications();
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
    final message = await api.updateRequest(
      "/notification/read-notification",
      {},
      authRequired: true,
    );

    for (var i in notifications.entries) {
      for (var j in i.value) {
        j['read'] = true;
      }
    }

    if (message?['success'] == true) {
      unreadNotifications.value = 0;
    }
  }

  void sortNotifications() {
    final sortedKeys =
        notifications.keys.toList()..sort((a, b) => b.compareTo(a));

    final sortedNotifications = <DateTime, List<Map<String, dynamic>>>{};

    for (var key in sortedKeys) {
      sortedNotifications[key] =
          notifications[key]!.toList()..sort(
            (a, b) => DateTime.parse(
              b['createdAt'],
            ).compareTo(DateTime.parse(a['createdAt'])),
          );
    }

    notifications.assignAll(sortedNotifications);
  }
}
