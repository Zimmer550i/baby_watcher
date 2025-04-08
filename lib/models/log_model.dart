import 'dart:convert';
import 'package:flutter/material.dart';

LogModel logModelFromJson(String str) => LogModel.fromJson(json.decode(str));

String logModelToJson(LogModel data) => json.encode(data.toJson());

class LogModel {
  DateTime date;
  TimeOfDay time;
  String? activity;
  String name;
  String user;
  String babySitter;
  String status;
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  bool isCompleted;

  LogModel({
    required this.date,
    required this.time,
    required this.activity,
    required this.name,
    required this.user,
    required this.babySitter,
    required this.status,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.isCompleted = false,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) => LogModel(
    date: DateTime.parse(json["date"]).add(Duration(days: 1)),
    time: _parseTime(json["time"]),
    activity: json["activity"],
    name: json["activity"] == "Others" ? json["otherAct"] : json["activity"],
    user: json["user"],
    babySitter: json["babySitter"],
    status: json["status"],
    isCompleted: json["status"] == "complete",
    id: json["_id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "date": date.toIso8601String(),
    "time": _formatTime(time),
    "activity": activity,
    "otherAct": name,
    "user": user,
    "babySitter": babySitter,
    "status": status,
    "_id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };

  // Helper: Convert "08:45 PM" -> TimeOfDay
  static TimeOfDay _parseTime(String timeStr) {
    final format = RegExp(r'(\d+):(\d+) (\w{2})');
    final match = format.firstMatch(timeStr);
    if (match != null) {
      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2)!);
      if (match.group(3) == 'PM' && hour != 12) hour += 12;
      if (match.group(3) == 'AM' && hour == 12) hour = 0;
      return TimeOfDay(hour: hour, minute: minute);
    }
    return const TimeOfDay(hour: 0, minute: 0); // Default fallback
  }

  // Helper: Convert TimeOfDay -> "08:45 PM"
  static String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }
}
