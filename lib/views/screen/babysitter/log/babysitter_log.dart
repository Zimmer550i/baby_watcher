import 'package:baby_watcher/controllers/log_controller.dart';
import 'package:baby_watcher/models/log_model.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/show_snackbar.dart';
import 'package:baby_watcher/views/base/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BabysitterLog extends StatefulWidget {
  const BabysitterLog({super.key});

  @override
  State<BabysitterLog> createState() => _BabysitterLogState();
}

class _BabysitterLogState extends State<BabysitterLog> {
  var now = DateTime.now();
  final logController = Get.find<LogController>();

  @override
  void initState() {
    super.initState();
    logController.getLogs(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
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
              child: Obx(() {
                return RefreshIndicator(
                  onRefresh:
                      () => logController.getLogs(
                        DateTime.now().add(const Duration(days: 1)),
                      ),
                  child:
                      logController.isLoading.value
                          ? Align(
                            alignment: Alignment.topCenter,
                            child: CircularProgressIndicator(),
                          )
                          : logController.logs.isEmpty
                          ? Center(
                            child: Text(
                              "No logs added yet",
                              style: TextStyle(
                                fontVariations: [FontVariation("wght", 500)],
                                fontSize: 30,
                                color: AppColors.indigo,
                              ),
                            ),
                          )
                          : ListView.builder(
                            itemCount: logController.logs.length,
                            itemBuilder: (context, index) {
                              return logWidget(logController.logs[index]);
                            },
                          ),
                );
              }),
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
  final controller = Get.find<LogController>();

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
            Checkbox(
              value: item.isCompleted,
              onChanged: (val) async {
                final message = await controller.acceptLog(item);

                if (message == "Success") {
                  await controller.getLogs(DateTime.now());
                } else {
                  showSnackBar(message);
                }
              },
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
