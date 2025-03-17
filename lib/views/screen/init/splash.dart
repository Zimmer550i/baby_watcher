import 'package:baby_watcher/controllers/auth_controller.dart';
import 'package:baby_watcher/controllers/user_controller.dart';
import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final auth = Get.find<AuthController>();
      bool? isLoggedIn;

      if (await auth.checkLoginStatus()) {
        isLoggedIn = true;
      } else {
        isLoggedIn = false;
      }

      Future.delayed(const Duration(milliseconds: 1000), () async {
        int count = 0;
        while (isLoggedIn == null && count < 2) {
          Future.delayed(Duration(milliseconds: 1000));
          count++;
        }

        if (isLoggedIn == true) {
          final user = Get.find<UserController>();
          if (user.userRole == Role.parent) {
            Get.offNamed(AppRoutes.parentApp);
          } else {
            Get.offNamed(AppRoutes.babysitterApp);
          }
        } else {
          Get.offNamed(AppRoutes.welcome);
        }
      });
    });
    return Scaffold(
      backgroundColor: AppColors.indigo,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SvgPicture.asset(AppIcons.logo),

          const SizedBox(height: 12),
          Text(
            "Baby Watcher",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 36,
              color: Color(0xffEEF2FF),
              fontVariations: [FontVariation('wght', 600)],
            ),
          ),
        ],
      ),
    );
  }
}
