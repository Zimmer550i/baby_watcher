import 'package:baby_watcher/views/screen/auth/connect_mothers_account.dart';
import 'package:baby_watcher/views/screen/auth/forgot_password.dart';
import 'package:baby_watcher/views/screen/auth/otp_verification.dart';
import 'package:baby_watcher/views/screen/auth/reset_password.dart';
import 'package:baby_watcher/views/screen/auth/signin.dart';
import 'package:baby_watcher/views/screen/auth/signup.dart';
import 'package:baby_watcher/views/screen/auth/verify_email.dart';
import 'package:baby_watcher/views/screen/babysitter/babysitter_app.dart';
import 'package:baby_watcher/views/screen/common/connections.dart';
import 'package:baby_watcher/views/screen/common/notifications.dart';
import 'package:baby_watcher/views/screen/common/profile_information.dart';
import 'package:baby_watcher/views/screen/auth/role_select.dart';
import 'package:baby_watcher/views/screen/init/splash.dart';
import 'package:baby_watcher/views/screen/init/welcome.dart';
import 'package:baby_watcher/views/screen/parent/emergency/parent_add_contact.dart';
import 'package:baby_watcher/views/screen/parent/emergency/parent_edit_contact.dart';
import 'package:baby_watcher/views/screen/parent/log/add_log.dart';
import 'package:baby_watcher/views/screen/parent/parent_app.dart';
import 'package:baby_watcher/views/screen/parent/profile/parent_card_details.dart';
import 'package:baby_watcher/views/screen/parent/profile/parent_confirmation.dart';
import 'package:baby_watcher/views/screen/parent/profile/parent_not_connected.dart';
import 'package:baby_watcher/views/screen/parent/profile/parent_payment_method.dart';
import 'package:baby_watcher/views/screen/parent/profile/parent_subscription.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String splashScreen = "/splash_screen";
  static String welcome = "/welcome";
  static String roleSelect = "/role_select";

  static String signUp = '/sign_up';
  static String signIn = '/sign_in';
  static String verifyEmail = '/verify_email';
  static String forgotPassword = '/forgot_password';
  static String otpVerification = '/otp_verification';
  static String resetPasword = '/reset_password';
  static String connectMothersAccount = '/connect_mothers_account';
  static String notifications = '/notifications';
  static String profileInformation = '/profile_information';
  static String connections = '/connections';

  static String parentApp = '/parent_app';
  static String parentSubscription = '/parent_subscription';
  static String parentPaymentMethod = '/parent_payment_method';
  static String parentCardDetails = '/parent_card_details';
  static String parentConfirmation = '/parent_congratulations';
  static String parentNotConnected = '/parent_not_connected';

  static String parentAddContact = '/parent_add_contact';
  static String parentEditContact = '/parent_edit_contact';

  static String addLog = '/add_log';

  static String babysitterApp = "/babysitter_app";

  static Map<String, Widget> routeWidgets = {
    splashScreen: Splash(),
    welcome: Welcome(),
    roleSelect: RoleSelect(),
    signUp: Signup(),
    signIn: Signin(),
    verifyEmail: VerifyEmail(),
    forgotPassword: ForgotPassword(),
    otpVerification: OtpVerification(),
    resetPasword: ResetPassword(),
    connectMothersAccount: ConnectMothersAccount(),
    parentApp: ParentApp(),
    babysitterApp: BabysitterApp(),
    addLog: AddLog(),
    notifications: Notifications(),
    profileInformation: ProfileInformation(),
    parentSubscription: ParentSubscription(),
    parentPaymentMethod: ParentPaymentMethod(),
    parentCardDetails: ParentCardDetails(),
    parentConfirmation: ParentConfirmation(),
    parentNotConnected: ParentNotConnected(),
    connections: Connections(),
    parentAddContact: ParentAddContact(),
    parentEditContact: ParentEditContact(),
  };

  static List<GetPage> pages = [
    ...routeWidgets.entries.map(
      (e) => GetPage(name: e.key, page: () => e.value),
    ),
  ];
}
