import 'package:flutter/material.dart';

enum LogType { meal, medicine, nap, physicalActivity, shower, others }

class LogModel {
  String name;
  LogType type;
  TimeOfDay time;
  bool isCompleted;

  LogModel({
    this.name = "",
    this.type = LogType.others,
    required this.time,
    this.isCompleted = false,
  }) {
    name = type.toString().substring(type.toString().indexOf('.') + 1);
    name = name[0].toUpperCase() + name.substring(1);
  }
}
