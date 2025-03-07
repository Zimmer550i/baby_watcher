class NotificationModel {
  String title;
  String subTitle;
  DateTime time;
  bool isUnseen;

  NotificationModel({
    required this.title,
    required this.subTitle,
    required this.time,
    this.isUnseen = false,
  });
}
