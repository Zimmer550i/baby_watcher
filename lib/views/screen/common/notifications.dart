import 'package:baby_watcher/controllers/socket_controller.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final socketController = Get.find<SocketController>();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 1) {
        socketController.getMoreNotification();
      }
    });
  }

  @override
  void dispose() {
    socketController.readNotifications();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Notifications"),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SafeArea(
              child: Obx(
                () => Column(
                  children: [
                    ...getNotifications(socketController.notifications),
                    if (socketController.loadingNotifications)
                      Padding(
                        padding: const EdgeInsets.all(80.0),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getNotifications(
    Map<DateTime, List<Map<String, dynamic>>> data,
  ) {
    List<Widget> rtn = [];

    final sortedKeys = data.keys.toList()..sort((a, b) => b.compareTo(a));

    for (var i in sortedKeys) {
      rtn.add(
        Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              formatDate(i),
              style: TextStyle(
                fontSize: 16,
                fontVariations: [FontVariation("wght", 500)],
                color: Color(0xff2d2d2d),
              ),
            ),
          ),
        ),
      );
      for (var j in data[i]!) {
        rtn.add(notificationWidget(j, data[i]!.last == j));
      }
    }

    return rtn;
  }

  String formatDate(DateTime t) {
    final now = DateTime.now();
    final List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    if (t.year == now.year && t.month == now.month && t.day == now.day) {
      return "Today";
    } else if (t.year == now.year &&
        t.month == now.month &&
        now.day - t.day == 1) {
      return "Yesterday";
    } else if (t.year == now.year &&
        t.month == now.month &&
        t.day - now.day == 1) {
      return "Tomorrow";
    } else {
      return "${t.day} ${months[t.month - 1]} ${t.year}";
    }
  }

  Widget notificationWidget(Map<String, dynamic> item, bool showBoarder) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: !item['read'] ? AppColors.indigo : null,
          borderRadius: BorderRadius.circular(!item['read'] ? 8 : 0),
          border: Border(
            bottom:
                showBoarder
                    ? BorderSide(color: Colors.transparent)
                    : BorderSide(color: AppColors.indigo[100]!),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.indigo[!item['read'] ? 25 : 50],
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppIcons.notification,
                  colorFilter: ColorFilter.mode(
                    AppColors.indigo,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['text'],
                    style: TextStyle(
                      fontVariations: [FontVariation("wght", 600)],
                      fontSize: 14,
                      color: !item['read'] ? Colors.white : Color(0xff3a3a3a),
                    ),
                  ),
                  // Text(
                  //   item.subTitle,
                  //   style: TextStyle(
                  //     fontVariations: [FontVariation("wght", 400)],
                  //     fontSize: 12,
                  //     color: item.isUnseen ? Colors.white : Color(0xff525252),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(width: 30),
          ],
        ),
      ),
    );
  }
}
