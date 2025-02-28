import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

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
            CustomTextField(leading: AppIcons.user, hintText: "Name"),
            const SizedBox(height: 16),
            CustomTextField(leading: AppIcons.email, hintText: "Email"),
            const SizedBox(height: 16),
            CustomTextField(leading: AppIcons.phone, hintText: "Phone Number"),
            const SizedBox(height: 16),
            CustomTextField(isPassword: true, hintText: "Password"),
            const SizedBox(height: 16),
            CustomTextField(isPassword: true, hintText: "Confirm Password"),
            const SizedBox(height: 36),
            CustomButton(text: "Signup"),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 400)],
                    fontSize: 12,
                    color: AppColors.gray.shade400,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Get.offNamed(AppRoutes.signIn);
                  },
                  child: Text(
                    " Log In ",
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
