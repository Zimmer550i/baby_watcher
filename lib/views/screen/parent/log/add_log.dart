import 'package:baby_watcher/controllers/log_controller.dart';
import 'package:baby_watcher/models/log_model.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/formatter.dart';
import 'package:baby_watcher/utils/show_snackbar.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/custom_drop_down.dart';
import 'package:baby_watcher/views/base/custom_text_field.dart';
import 'package:baby_watcher/views/base/overlay_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';

class AddLog extends StatefulWidget {
  final LogModel? log;
  final DateTime? date;
  const AddLog({super.key, this.log, this.date});

  @override
  State<AddLog> createState() => _AddLogState();
}

class _AddLogState extends State<AddLog> {
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final nameController = TextEditingController();
  final logController = Get.find<LogController>();
  DateTime? date;
  TimeOfDay? time;
  String? activity;

  @override
  void initState() {
    super.initState();

    if (widget.log != null) {
      date = widget.log!.date;
      time = widget.log!.time;
      nameController.text = widget.log!.name;
      activity =
          widget.log!.activity![0].toUpperCase() +
          widget.log!.activity!.substring(1);
      if (time != null) {
        timeController.text =
            "${(time!.hourOfPeriod).toString().padLeft(2, "0")}:${(time!.minute).toString().padLeft(2, "0")}";
        if (time!.period == DayPeriod.am) {
          timeController.text = "${timeController.text} AM";
        } else {
          timeController.text = "${timeController.text} PM";
        }
      }
    } else {
      date = widget.date;
    }
    if (date != null) {
      dateController.text =
          "${(date!.day).toString().padLeft(2, "0")}/${(date!.month).toString().padLeft(2, "0")}/${date!.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(widget.log == null ? "Add New Log" : "Edit Log"),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 24),
                CustomTextField(
                  title: "Choose Date",
                  hintText: "Pick a Date",
                  trailing: AppIcons.calendar,
                  controller: dateController,
                  onTap: () async {
                    date = await showDatePicker(
                      context: context,
                      initialDate: date ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2050),
                    );

                    if (date != null) {
                      dateController.text =
                          "${(date!.day).toString().padLeft(2, "0")}/${(date!.month).toString().padLeft(2, "0")}/${date!.year}";
                    }
                  },
                ),
                const SizedBox(height: 24),
                CustomDropDown(
                  initialPick: activity,
                  options: [
                    "Meal",
                    "Medicine",
                    "Nap",
                    "Physical Activity",
                    "Shower",
                    "Others",
                  ],
                  onChanged:
                      (p0) => setState(() {
                        activity = p0;
                      }),
                  title: "Select Activity",
                  hintText: "Select One",
                ),
                const SizedBox(height: 24),
                if (activity == "Others")
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: CustomTextField(
                      title: "Activity Name",
                      hintText: "Enter a Name",
                      controller: nameController,
                    ),
                  ),
                CustomTextField(
                  title: "Set Time",
                  hintText: "Pick a Time",
                  trailing: AppIcons.clock,
                  controller: timeController,
                  onTap: () async {
                    time = await showTimePicker(
                      context: context,
                      initialTime: time ?? TimeOfDay.now(),
                    );

                    if (time != null) {
                      timeController.text =
                          "${(time!.hourOfPeriod).toString().padLeft(2, "0")}:${(time!.minute).toString().padLeft(2, "0")}";
                      if (time!.period == DayPeriod.am) {
                        timeController.text = "${timeController.text} AM";
                      } else {
                        timeController.text = "${timeController.text} PM";
                      }
                    }
                  },
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.log != null)
                      Expanded(
                        flex: 2,
                        child: CustomButton(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => OverlayConfirmation(
                                    title: "Are you sure you want to delete",
                                    highlight: "${widget.log!.name}?",
                                    buttonTextLeft: "No",
                                    leftButtonIsSecondary: false,
                                    buttonCallBackLeft: () => Get.back(),
                                    buttonTextRight: "Yes",
                                    buttonCallBackRight: () async {
                                      final response = await logController
                                          .deleteLog(widget.log!.id.toString());

                                      if (response == "Success") {
                                        Get.back();
                                        Get.back();
                                        showSnackBar(
                                          "Log Deleted",
                                          isError: false,
                                        );
                                        Future.delayed(
                                          const Duration(seconds: 1),
                                          () => logController.getLogs(
                                            widget.log!.date.add(
                                              const Duration(days: 1),
                                            ),
                                          ),
                                        );
                                      } else {
                                        Get.back();
                                        showSnackBar(response);
                                      }
                                    },
                                  ),
                            );
                          },
                          text: "Delete",
                          isSecondary: true,
                        ),
                      ),
                    if (widget.log != null) const SizedBox(width: 20),
                    if (widget.log == null) const Spacer(),
                    if (widget.log != null)
                      Expanded(
                        flex: 2,
                        child: CustomButton(text: "Update", onTap: updateLog),
                      ),
                    if (widget.log == null)
                      Expanded(
                        flex: 2,
                        child: CustomButton(text: "Save", onTap: createLog),
                      ),

                    if (widget.log == null) const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateLog() async {
    bool sameTime = widget.log!.time.isAtSameTimeAs(time ?? TimeOfDay.now());
    widget.log!.activity = activity;
    widget.log!.date = date ?? DateTime.now();
    widget.log!.time = time ?? TimeOfDay.now();
    widget.log!.name = nameController.text;
    final response = await logController.updateLog(widget.log!, !sameTime);
    if (response == "Success") {
      Get.back();
      Get.back();
      showSnackBar("Log Updated", isError: false);
      Future.delayed(
        const Duration(seconds: 1),
        () => logController.getLogs(
          widget.log!.date.add(const Duration(days: 1)),
        ),
      );
    } else {
      Get.back();
      showSnackBar(response);
    }
  }

  createLog() async {
    String formatedTime = Formatter.timeFormatter(
      time: time ?? TimeOfDay.now(),
    );
    String formatedDate = Formatter.dateFormatter(date ?? DateTime.now());

    final data = {
      "activity": activity,
      "otherAct": activity == "Others" ? nameController.text : activity,
      "time": formatedTime,
      "date": formatedDate,
    };

    final response = await logController.createLog(data);
    if (response == "Success") {
      Get.back();
      showSnackBar("Log Created", isError: false);
      Future.delayed(
        const Duration(seconds: 1),
        () => logController.getLogs(widget.date ?? DateTime.now()),
      );
    } else {
      Get.back();
      showSnackBar(response);
    }
  }
}
