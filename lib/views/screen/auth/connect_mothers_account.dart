import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ConnectMothersAccount extends StatelessWidget {
  const ConnectMothersAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SvgPicture.asset(
                  AppIcons.logo,
                  colorFilter: ColorFilter.mode(
                    AppColors.indigo.shade200,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Connect to Mother’s Account",
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 600)],
                    fontSize: 24,
                    color: AppColors.indigo,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Enter the unique key given by the mother to get access to their activities and tasks.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 400)],
                    fontSize: 16,
                    color: AppColors.gray,
                  ),
                ),
                const SizedBox(height: 28),
                CustomTextField(
                  leading: AppIcons.key,
                  hintText: "Enter Unique Key",
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: "Connect",
                  onTap: () {
                    Get.offAllNamed(AppRoutes.babysitterApp);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}