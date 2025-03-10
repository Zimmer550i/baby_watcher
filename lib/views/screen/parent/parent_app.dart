import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/screen/common/messages.dart';
import 'package:baby_watcher/views/screen/common/profile.dart';
import 'package:baby_watcher/views/screen/parent/log/parent_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ParentApp extends StatefulWidget {
  const ParentApp({super.key});

  @override
  State<ParentApp> createState() => _ParentAppState();
}

class _ParentAppState extends State<ParentApp> {
  int index = 0;
  PageController controller = PageController(initialPage: 0);
  List<Widget> pages = [
    ParentLog(),
    Center(child: Text("Page 2")),
    Center(child: Text("Page 3")),
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
  List<int> notifications = [0, 0, 1, 2, 0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(controller: controller, children: pages),
      bottomNavigationBar: BottomNavigationBar(
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
            controller.jumpToPage(index);
          });
        },
        items: [items(0), items(1), items(2), items(3), items(4)],
      ),
    );
  }

  BottomNavigationBarItem items(int pos) {
    return BottomNavigationBarItem(
      icon: Stack(
        alignment: Alignment.topRight,
        children: [
          SvgPicture.asset(pageAssets[pos]),
          if (notifications[pos] != 0)
            Container(
              height: 14,
              width: 14,
              decoration: BoxDecoration(
                color: AppColors.indigo,
                shape: BoxShape.circle,
              ),
              child: FittedBox(child: Text(notifications[pos].toString(), style: TextStyle(
                fontVariations: [FontVariation("wght", 500)],
                color: Colors.white,
              ),)),
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
          if (notifications[pos] != 0)
            Container(
              height: 14,
              width: 14,
              decoration: BoxDecoration(
                color: AppColors.indigo[25],
                shape: BoxShape.circle,
              ),
              child: FittedBox(child: Text(notifications[pos].toString(), style: TextStyle(
                fontVariations: [FontVariation("wght", 500)],
                color: AppColors.indigo,
              ),)),
            ),
        ],
      ),
      label: pageNames[pos],
    );
  }
}
