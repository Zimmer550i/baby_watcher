import 'package:baby_watcher/models/notification_model.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ParentNotification extends StatelessWidget {
  const ParentNotification({super.key});

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<NotificationModel>> data = {
      DateTime.now(): [
        NotificationModel(
          title: "Activity Completed: Nap",
          subTitle:
              "Your babysitter confirmed that the Nap was completd at 2:00 PM",
          time: DateTime.now(),
          isUnseen: true,
        ),
      ],
      DateTime.now().subtract(const Duration(days: 1)): [
        NotificationModel(
          title: "Activity Completed: Nap",
          subTitle:
              "Your babysitter confirmed that the activity was completd at 2:00 PM",
          time: DateTime.now(),
        ),
        NotificationModel(
          title: "Missed Activity: Medicine",
          subTitle:
              "The scheduled medicine at 3:00 PM was not confirmed by the Babysitter",
          time: DateTime.now(),
        ),
      ],
      DateTime.now().subtract(const Duration(days: 2)): [
        NotificationModel(
          title: "New Video Recieved",
          subTitle: "Your babysitter shared a new video update",
          time: DateTime.now(),
        ),
        NotificationModel(
          title: "Activity Completed: Nap",
          subTitle:
              "Your babysitter confirmed that the activity was completd at 2:00 PM",
          time: DateTime.now(),
        ),
        NotificationModel(
          title: "Activity Completed: Nap",
          subTitle:
              "Your babysitter confirmed that the activity was completd at 2:00 PM",
          time: DateTime.now(),
        ),
      ],
      DateTime.now().subtract(const Duration(days: 2)): [
        NotificationModel(
          title: "New Video Recieved",
          subTitle: "Your babysitter shared a new video update",
          time: DateTime.now(),
        ),
        NotificationModel(
          title: "Activity Completed: Nap",
          subTitle:
              "Your babysitter confirmed that the activity was completd at 2:00 PM",
          time: DateTime.now(),
        ),
        NotificationModel(
          title: "Activity Completed: Nap",
          subTitle:
              "Your babysitter confirmed that the activity was completd at 2:00 PM",
          time: DateTime.now(),
        ),
      ],
    };

    return Scaffold(
      appBar: customAppBar("Notifications"),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SafeArea(child: Column(children: getNotifications(data))),
          ),
        ),
      ),
    );
  }

  List<Widget> getNotifications(Map<DateTime, List<NotificationModel>> data) {
    List<Widget> rtn = [];

    for (var i in data.keys) {
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

  Widget notificationWidget(NotificationModel item, bool showBoarder) {
    return GestureDetector(
      onTap: () {
        
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: item.isUnseen ? AppColors.indigo : null,
          borderRadius: BorderRadius.circular(item.isUnseen ? 8 : 0),
          border: Border(
            bottom:
                showBoarder
                    ? BorderSide(color: Colors.transparent)
                    : BorderSide(color: AppColors.indigo[100]!),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.indigo[item.isUnseen ? 25 : 50],
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
                    item.title,
                    style: TextStyle(
                      fontVariations: [FontVariation("wght", 600)],
                      fontSize: 14,
                      color: item.isUnseen ? Colors.white : Color(0xff3a3a3a),
                    ),
                  ),
                  Text(
                    item.subTitle,
                    style: TextStyle(
                      fontVariations: [FontVariation("wght", 400)],
                      fontSize: 12,
                      color: item.isUnseen ? Colors.white : Color(0xff525252),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
