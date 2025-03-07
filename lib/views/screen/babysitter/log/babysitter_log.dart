import 'package:baby_watcher/models/log_model.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BabysitterLog extends StatelessWidget {
  const BabysitterLog({super.key});

  @override
  Widget build(BuildContext context) {
    List<LogModel> logs = [
      LogModel(
        type: LogType.meal,
        time: TimeOfDay(hour: 13, minute: 30),
        isCompleted: true,
      ),
      LogModel(
        type: LogType.nap,
        time: TimeOfDay(hour: 14, minute: 00),
        isCompleted: true,
      ),
      LogModel(type: LogType.medicine, time: TimeOfDay(hour: 15, minute: 00)),
      LogModel(type: LogType.shower, time: TimeOfDay(hour: 16, minute: 00)),
      LogModel(
        type: LogType.physicalActivity,
        time: TimeOfDay(hour: 16, minute: 30),
      ),
      LogModel(type: LogType.meal, time: TimeOfDay(hour: 20, minute: 00)),
    ];
    var now = DateTime.now();

    return Scaffold(
      appBar: homeAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 24, bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${now.day.toString().padLeft(2, "0")} ${["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"][now.month - 1]}, ${now.year}",
                  style: TextStyle(
                    fontSize: 14,
                    fontVariations: [FontVariation("wght", 400)],
                    color: AppColors.gray,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  return logWidget(logs[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget logWidget(LogModel item) {
  bool isPast = item.time.isBefore(TimeOfDay.now());
  bool notConfirmed = !item.isCompleted && isPast;
  // notConfirmed = true;

  var now = DateTime.now();
  var lateTime = now.difference(
    DateTime(now.year, now.month, now.day, item.time.hour, item.time.minute),
  );
  String late =
      lateTime.inHours >= 1
          ? "${lateTime.inHours} Hour"
          : "${lateTime.inMinutes} Minutes";

  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: GestureDetector(
      onTap: () {
        // Get.to(() => AddLog(log: item));
      },
      child: Container(
        // height: 74,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: item.isCompleted ? AppColors.indigo[100] : Colors.white,
          // ignore: dead_code
          border:
              item.isCompleted
                  ? Border.all(color: AppColors.indigo)
                  : notConfirmed
                  ? Border.all(color: Color(0xffC84949))
                  : null,
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.indigo[50],
              ),
              child: Center(
                child: SvgPicture.asset(switch (item.type) {
                  LogType.meal => AppIcons.meal,
                  LogType.nap => AppIcons.nap,
                  LogType.medicine => AppIcons.med,
                  LogType.shower => AppIcons.shower,
                  LogType.physicalActivity => AppIcons.physical,
                  LogType.others => AppIcons.motherWithBaby,
                }),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 400)],
                    fontSize: 18,
                    color: AppColors.gray[600],
                  ),
                ),
                Row(
                  children: [
                    SvgPicture.asset(AppIcons.clock),
                    const SizedBox(width: 4),
                    Text(
                      formatTime(item.time),
                      style: TextStyle(
                        fontVariations: [FontVariation("wght", 500)],
                        fontSize: 14,
                        color: AppColors.gray[600],
                      ),
                    ),
                  ],
                ),
                if (notConfirmed)
                  Text(
                    "*You are late $late",
                    style: TextStyle(
                      fontSize: 12,
                      fontVariations: [FontVariation("wght", 500)],
                      color: Color(0xffFF3030),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Checkbox(value: item.isCompleted, onChanged: (val) {}),
          ],
        ),
      ),
    ),
  );
}

String formatTime(TimeOfDay time) {
  String rtn = "";

  rtn += time.hourOfPeriod.toString();
  rtn += ":";
  rtn += time.minute.toString().padLeft(2, "0");
  rtn += " ";
  rtn += time.period == DayPeriod.am ? "AM" : "PM";

  return rtn;
}
