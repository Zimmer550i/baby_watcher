import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/models/log_model.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ParentLog extends StatefulWidget {
  const ParentLog({super.key});

  @override
  State<ParentLog> createState() => _ParentLogState();
}

class _ParentLogState extends State<ParentLog> {
  List<DateTime> days = [];
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
  int selected = 0;

  @override
  void initState() {
    super.initState();
    var temp = DateTime(DateTime.now().year, DateTime.now().month, 1);
    int count = 0;
    while (temp.month == DateTime.now().month) {
      days.add(temp);
      temp = temp.add(const Duration(days: 1));
      if (temp.day == DateTime.now().day) {
        count++;
        selected = count;
      } else {
        count++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(),
      floatingActionButton: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.addLog);
        },
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: AppColors.indigo,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 5,
                // spreadRadius: 2,
                color: Colors.black.withAlpha(50),
              ),
            ],
          ),
          child: Icon(Icons.add_rounded, color: Colors.white, size: 40),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                "February, 2025",
                style: TextStyle(
                  fontVariations: [FontVariation("wght", 500)],
                  fontSize: 18,
                  color: AppColors.gray[700],
                ),
              ),
            ),
            SizedBox(
              height: 58,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: days.length,
                controller: ScrollController(
                  initialScrollOffset:
                      (selected / 2).ceil() * 50 + (selected * 16),
                ),
                itemBuilder: (context, index) {
                  return dayWidget(index);
                },
              ),
            ),
            const SizedBox(),
            Text(
              "Today's Log",
              style: TextStyle(
                fontVariations: [FontVariation("wght", 500)],
                fontSize: 18,
                color: AppColors.gray[700],
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

  AppBar homeAppBar() {
    return AppBar(
      backgroundColor: AppColors.indigo[25],
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: SvgPicture.asset(
            AppIcons.logo,
            height: 32,
            width: 32,
            colorFilter: ColorFilter.mode(
              AppColors.indigo[200]!,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      actions: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            SvgPicture.asset(AppIcons.notification),
            // if (notifications[pos] != 0)
            Container(
              height: 14,
              width: 14,
              decoration: BoxDecoration(
                color: AppColors.indigo,
                shape: BoxShape.circle,
              ),
              child: FittedBox(
                child: Text(
                  "1",
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 500)],
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Padding dayWidget(int index) {
    return Padding(
      padding: EdgeInsets.only(right: index == days.length - 1 ? 0 : 16),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selected = index;
          });
        },
        child: Container(
          height: 58,
          width: 50,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color:
                index == selected
                    ? AppColors.indigo[100]
                    : AppColors.indigo[50],
            borderRadius: BorderRadius.circular(4),
            border:
                index == selected ? Border.all(color: AppColors.indigo) : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getWeekday(days[index]).toUpperCase(),
                style: TextStyle(
                  fontVariations: [FontVariation("wght", 400)],
                  fontSize: 12,
                  color: AppColors.gray[600],
                ),
              ),
              Text(
                days[index].day.toString(),
                style: TextStyle(
                  fontVariations: [FontVariation("wght", 600)],
                  fontSize: 16,
                  color: AppColors.gray[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getWeekday(DateTime date) {
    return date.weekday == 1
        ? "Mon"
        : date.weekday == 2
        ? "Tue"
        : date.weekday == 3
        ? "Wed"
        : date.weekday == 4
        ? "Thu"
        : date.weekday == 5
        ? "Fri"
        : date.weekday == 6
        ? "Sat"
        : "Sun";
  }

  Widget logWidget(LogModel item) {
    bool isPast = item.time.isBefore(TimeOfDay.now());
    bool notConfirmed = !item.isCompleted && isPast;
    // notConfirmed = true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        height: 74,
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
              ],
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color:
                    item.isCompleted
                        ? Color(0xff76FF76)
                        : isPast
                        ? Color(0xffFE8A8A)
                        : AppColors.yellow[100],

                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                item.isCompleted
                    ? "Completed"
                    : isPast
                    ? "Not Confirmed"
                    : "Upcomming",
                style: TextStyle(
                  color:
                      item.isCompleted
                          ? Color(0xff095209)
                          : isPast
                          ? Color(0xff6A2626)
                          : AppColors.yellow.shade700,
                  fontSize: 12,
                  fontVariations: [FontVariation("wght", 500)],
                ),
              ),
            ),
          ],
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
}
