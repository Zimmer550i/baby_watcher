import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Signin extends StatelessWidget {
  const Signin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.logo,
              colorFilter: ColorFilter.mode(
                AppColors.indigo.shade200,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 28),
            CustomTextField(leading: AppIcons.email, hintText: "Email"),
            const SizedBox(height: 16),
            CustomTextField(isPassword: true, hintText: "Password"),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.forgotPassword);
                },
                child: Text(
                  " Forget Password ",
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 400)],
                    fontSize: 12,
                    color: AppColors.indigo,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 36),
            CustomButton(
              text: "Login",
              onTap: () {
                Get.offAllNamed(AppRoutes.parentApp);
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 400)],
                    fontSize: 12,
                    color: AppColors.gray.shade400,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Get.offNamed(AppRoutes.roleSelect);
                  },
                  child: Text(
                    " SignUp ",
                    style: TextStyle(
                      fontVariations: [FontVariation("wght", 400)],
                      fontSize: 12,
                      color: AppColors.indigo,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
