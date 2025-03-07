import 'package:flutter/material.dart';

enum LogType { meal, medicine, nap, physicalActivity, shower, others }

class LogModel {
  String name;
  LogType type;
  TimeOfDay time;
  DateTime? date;
  bool isCompleted;

  LogModel({
    this.name = "",
    this.type = LogType.others,
    required this.time,
    this.date,
    this.isCompleted = false,
  }) {
    name = type.toString().substring(type.toString().indexOf('.') + 1);
    name = name[0].toUpperCase() + name.substring(1);
    date = DateTime.now();
  }
}
