// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_collection_literals

import 'dart:convert';
import 'package:baby_watcher/controllers/api_service.dart';
import 'package:baby_watcher/controllers/auth_controller.dart';
import 'package:baby_watcher/controllers/emergency_controller.dart';
import 'package:baby_watcher/controllers/log_controller.dart';
import 'package:baby_watcher/controllers/message_controller.dart';
import 'package:baby_watcher/controllers/monitor_controller.dart';
import 'package:baby_watcher/controllers/socket_controller.dart';
import 'package:baby_watcher/controllers/user_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/home_controller.dart';
import '../controllers/localization_controller.dart';
import '../controllers/theme_controller.dart';
import '../models/language_model.dart';
import '../utils/app_constants.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

  // Repository

  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => HomeController());
  // Get.lazyPut(() => UserController(), fenix: true);
  Get.put(ApiService(), permanent: true);
  Get.put(UserController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  Get.put(LogController(), permanent: true);
  Get.put(MonitorController(), permanent: true);
  Get.put(EmergencyController(), permanent: true);
  Get.put(MessageController(), permanent: true);
  Get.put(SocketController(), permanent: true);

  //Retrieving localized data
  Map<String, Map<String, String>> _languages = Map();
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle.loadString(
      'assets/language/${languageModel.languageCode}.json',
    );
    Map<String, dynamic> _mappedJson = json.decode(jsonStringValues);
    Map<String, String> _json = Map();
    _mappedJson.forEach((key, value) {
      _json[key] = value.toString();
    });
    _languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        _json;
  }
  return _languages;
}
