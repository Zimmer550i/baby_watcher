import 'dart:async';

import 'package:baby_watcher/controllers/log_controller.dart';
import 'package:baby_watcher/models/log_model.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/formatter.dart';
import 'package:baby_watcher/views/base/home_app_bar.dart';
import 'package:baby_watcher/views/screen/parent/log/add_log.dart';
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
  int selected = 0;
  final logController = Get.find<LogController>();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    var temp = DateTime.now().subtract(const Duration(days: 7));
    int count = 0;
    for (; temp.isBefore(DateTime.now().add(const Duration(days: 13)));) {
      days.add(temp);
      temp = temp.add(const Duration(days: 1));
      if (temp.day == DateTime.now().day) {
        count++;
        selected = count;
      } else {
        count++;
      }
    }
    logController.getLogs(DateTime.now());
    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (val) => logController.getLogs(DateTime.now()),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(),
      floatingActionButton: GestureDetector(
        onTap: () {
          Get.to(() => AddLog(date: days[selected]));
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
                "${DateTime.now().day} ${Formatter.monthName(DateTime.now().month)}, ${DateTime.now().year}",
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
                  initialScrollOffset: ((selected - 2) * 50) + (selected * 16),
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
              child: Obx(() {
                if (logController.isLoading.value) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: CircularProgressIndicator(),
                  );
                } else if (logController.logs.isEmpty) {
                  return Column(
                    children: [
                      const Spacer(),
                      Text(
                        "No logs added yet",
                        style: TextStyle(
                          fontVariations: [FontVariation("wght", 500)],
                          fontSize: 30,
                          color: AppColors.indigo,
                        ),
                      ),
                      Text(
                        "Click this button to add one",
                        style: TextStyle(
                          fontVariations: [FontVariation("wght", 400)],
                          fontSize: 20,
                          color: AppColors.indigo[400],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 10,
                            top: 20,
                            bottom: 4,
                          ),
                          child: SvgPicture.asset(AppIcons.arrowCurve),
                        ),
                      ),
                      const SizedBox(height: 50 + 20),
                    ],
                  );
                } else {
                  return ListView.builder(
                    itemCount: logController.logs.length + 1,
                    itemBuilder: (context, index) {
                      if (index == logController.logs.length) {
                        return SizedBox(height: 55);
                      }
                      return logWidget(logController.logs[index]);
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
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
          logController.getLogs(days[index]);
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
    // return Text(item.id);
    bool isPast = item.time.isBefore(TimeOfDay.now());
    bool notConfirmed = !item.isCompleted && isPast;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () {
          Get.to(() => AddLog(log: item));
        },
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
                  child: SvgPicture.asset(switch (item.activity) {
                    "Meal" => AppIcons.meal,
                    "Nap" => AppIcons.nap,
                    "Medicine" => AppIcons.med,
                    "Shower" => AppIcons.shower,
                    "Physical Activity" => AppIcons.physical,
                    "Others" => AppIcons.motherWithBaby,
                    String() => AppIcons.motherWithBaby,
                    null => throw UnimplementedError(),
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
