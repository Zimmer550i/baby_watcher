import 'package:baby_watcher/controllers/message_controller.dart';
import 'package:baby_watcher/controllers/monitor_controller.dart';
import 'package:baby_watcher/controllers/socket_controller.dart';
import 'package:baby_watcher/controllers/user_controller.dart';
import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/screen/babysitter/emergency/babysitter_emergency.dart';
import 'package:baby_watcher/views/screen/babysitter/log/babysitter_log.dart';
import 'package:baby_watcher/views/screen/babysitter/monitor/babysitter_monitor.dart';
import 'package:baby_watcher/views/screen/common/messages.dart';
import 'package:baby_watcher/views/screen/common/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BabysitterApp extends StatefulWidget {
  const BabysitterApp({super.key});

  @override
  State<BabysitterApp> createState() => _BabysitterAppState();
}

class _BabysitterAppState extends State<BabysitterApp> {
  int index = 0;
  PageController controller = PageController(initialPage: 0);
  List<Widget> pages = [
    BabysitterLog(),
    BabysitterMonitor(),
    BabysitterEmergency(),
    Messages(),
    Profile(),
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
    Get.find<SocketController>().initialize();
    WidgetsBinding.instance.addPostFrameCallback((context) async {
      if (Get.find<UserController>().connectionId == null) {
        await Future.delayed(const Duration(milliseconds: 100));
        Get.offNamed(AppRoutes.connectMothersAccount);
      }
    });
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
            setState(() {
              index = value;
              if (index == 3) {
                Get.find<MessageController>().messageSeen();
              }
              controller.jumpToPage(index);
            });
          },
          items: [items(0), items(1), items(2), items(3), items(4)],
        ),
      ),
    );
  }

  BottomNavigationBarItem items(int pos) {
    return BottomNavigationBarItem(
      icon: Stack(
        alignment: Alignment.topRight,
        children: [
          SvgPicture.asset(pageAssets[pos]),
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
    if (pos == 1) return Get.find<MonitorController>().requestsCount.value;
    if (pos == 3) return Get.find<MessageController>().unreadMessages.value;

    return 0;
  }
}
