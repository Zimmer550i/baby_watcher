import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/custom_drop_down.dart';
import 'package:baby_watcher/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';

class AddLog extends StatefulWidget {
  const AddLog({super.key});

  @override
  State<AddLog> createState() => _AddLogState();
}

class _AddLogState extends State<AddLog> {
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  DateTime? date;
  TimeOfDay? time;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Add Log"),
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
                      initialDate: date,
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
                  options: [
                    "Meal",
                    "Medicine",
                    "Nap",
                    "Physical Activity",
                    "Shower",
                  ],
                  title: "Select Activity",
                  hintText: "Select One",
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  title: "Set Time",
                  hintText: "Pick a Time",
                  trailing: AppIcons.clock,
                  controller: timeController,
                  onTap: () async {
                    time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (time != null) {
                      timeController.text =
                          "${(time!.hourOfPeriod).toString().padLeft(2, "0")}:${(time!.minute).toString().padLeft(2, "0")}";
                      if (time!.period == DayPeriod.am) {
                        timeController.text = "${timeController.text} AM";
                      }else{
                        timeController.text = "${timeController.text} PM";
                      }
                    }
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: "Save",
                  width: MediaQuery.of(context).size.width / 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
