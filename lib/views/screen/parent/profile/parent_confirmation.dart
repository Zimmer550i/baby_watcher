import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ParentConfirmation extends StatelessWidget {
  const ParentConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(AppIcons.congrats),
            Text(
              "Congratulations",
              style: TextStyle(
                fontVariations: [FontVariation("wght", 500)],
                fontSize: 30,
                color: AppColors.gray[600],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "You have successfully purchased the Package. Now you can enjoy it over offline from my music tab, anytime anywhere.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontVariations: [FontVariation("wght", 400)],
                fontSize: 16,
                color: AppColors.gray,
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: "Back to Profile",
              width: null,
              onTap: () {
                Get.until((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
