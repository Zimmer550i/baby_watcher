import 'package:baby_watcher/views/screen/auth/signin.dart';
import 'package:baby_watcher/views/screen/auth/signup.dart';
import 'package:baby_watcher/views/screen/init/role_select.dart';
import 'package:baby_watcher/views/screen/init/splash.dart';
import 'package:baby_watcher/views/screen/init/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String splashScreen = "/splash_screen";
  static String welcome = "/welcome";
  static String roleSelect = "/role_select";

  static String signUp = '/sign_up';
  static String signIn = '/sign_in';

  static Map<String, Widget> routeWidgets = {
    splashScreen: Splash(),
    welcome: Welcome(),
    roleSelect: RoleSelect(),
    signUp : Signup(),
    signIn : Signin(),
  };

  static List<GetPage> pages = [
    ...routeWidgets.entries.map(
      (e) => GetPage(name: e.key, page: () => e.value),
    ),
  ];
}
