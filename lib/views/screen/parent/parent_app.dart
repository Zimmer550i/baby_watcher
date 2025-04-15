import 'package:baby_watcher/controllers/emergency_controller.dart';
import 'package:baby_watcher/controllers/message_controller.dart';
import 'package:baby_watcher/controllers/monitor_controller.dart';
import 'package:baby_watcher/controllers/socket_controller.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/screen/common/messages.dart';
import 'package:baby_watcher/views/screen/common/profile.dart';
import 'package:baby_watcher/views/screen/parent/emergency/parent_emergency.dart';
import 'package:baby_watcher/views/screen/parent/log/parent_log.dart';
import 'package:baby_watcher/views/screen/parent/monitor/parent_monitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ParentApp extends StatefulWidget {
  const ParentApp({super.key});

  @override
  State<ParentApp> createState() => _ParentAppState();
}

class _ParentAppState extends State<ParentApp> {
  int index = 0;
  bool isDisabled = false;
  late PageController controller;
  var socket = Get.find<SocketController>();
  List<Widget> pages = [
    ParentLog(key: PageStorageKey("parentLog")),
    ParentMonitor(key: PageStorageKey("parentMonitor")),
    ParentEmergency(key: PageStorageKey("parentEmergency")),
    Messages(key: PageStorageKey("parentMessages")),
    Profile(key: PageStorageKey("parentProfile")),
  ];
  List<String> pageNames = [
    "Log",
    "Monitor",
    "Emergency",
    "Messages",
    "Profile",
  ];
  List<String> pageAssets = [
    AppIcons.note,
    AppIcons.video,
    AppIcons.alarm,
    AppIcons.message,
    AppIcons.profile,
  ];

  @override
  void initState() {
    super.initState();
    if (socket.user.connectionId.value == null) {
      isDisabled = true;
      index = 4;
      controller = PageController(initialPage: index);
    } else {
      controller = PageController(initialPage: index);
    }
    socket.initialize();

    ever(
      socket.user.connectionId,
      (newId) => setState(() {
        if (socket.user.connectionId.value != null) {
          index = 1;
          isDisabled = false;
          controller.jumpToPage(1);
        } else {
          isDisabled = true;
          index = 4;
          controller.jumpToPage(index);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: pages,
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          showUnselectedLabels: false,
          currentIndex: index,
          useLegacyColorScheme: false,
          unselectedLabelStyle: TextStyle(color: Colors.amber),
          selectedFontSize: 12,
          selectedLabelStyle: TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.w400,
            color: Color(0xff222222),
          ),
          onTap: (value) {
            if (isDisabled) {
              return;
            }
            setState(() {
              index = value;
              if (index == 3) {
                Get.find<MessageController>().messageSeen();
              }
              controller.jumpToPage(index);
            });
          },
          items: [
            items(0, isDisabled: isDisabled),
            items(1, isDisabled: isDisabled),
            items(2, isDisabled: isDisabled),
            items(3, isDisabled: isDisabled),
            items(4),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem items(int pos, {bool isDisabled = false}) {
    return BottomNavigationBarItem(
      icon: Stack(
        alignment: Alignment.topRight,
        children: [
          SvgPicture.asset(
            pageAssets[pos],
            colorFilter:
                isDisabled
                    ? ColorFilter.mode(
                      Colors.grey.withAlpha(150),
                      BlendMode.srcIn,
                    )
                    : null,
          ),
          if (getAlertCount(pos) != 0)
            Container(
              height: 14,
              width: 14,
              decoration: BoxDecoration(
                color: AppColors.indigo,
                shape: BoxShape.circle,
              ),
              child: FittedBox(
                child: Text(
                  getAlertCount(pos).toString(),
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 500)],
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
      activeIcon: Stack(
        alignment: Alignment.topRight,
        children: [
          SvgPicture.asset(
            "${pageAssets[pos].substring(0, pageAssets[pos].length - 4)}_bold.svg",
            colorFilter: ColorFilter.mode(AppColors.indigo, BlendMode.srcIn),
          ),
          if (getAlertCount(pos) != 0)
            Container(
              height: 14,
              width: 14,
              decoration: BoxDecoration(
                color: AppColors.indigo[25],
                shape: BoxShape.circle,
              ),
              child: FittedBox(
                child: Text(
                  getAlertCount(pos).toString(),
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 500)],
                    color: AppColors.indigo,
                  ),
                ),
              ),
            ),
        ],
      ),
      label: pageNames[pos],
    );
  }

  int getAlertCount(int pos) {
    if (pos == 1) return Get.find<MonitorController>().unseenVideos.value;
    if (pos == 2) return Get.find<EmergencyController>().alerts.length;
    if (pos == 3) return Get.find<MessageController>().unreadMessages.value;

    return 0;
  }

  // int getAlerts(int n){
  //   switch(n){
  //     case 1:
  //       return Get.find<>()
  //   }
  // }
}
