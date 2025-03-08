  import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

AppBar homeAppBar() {
    return AppBar(
      backgroundColor: AppColors.indigo[25],
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: SvgPicture.asset(
            AppIcons.logo,
            height: 32,
            width: 32,
            colorFilter: ColorFilter.mode(
              AppColors.indigo[200]!,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      actions: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.parentNotification);
              },
              borderRadius: BorderRadius.circular(90),
              child: SvgPicture.asset(AppIcons.notification),
            ),
            // if (notifications[pos] != 0)
            Container(
              height: 14,
              width: 14,
              decoration: BoxDecoration(
                color: AppColors.indigo,
                shape: BoxShape.circle,
              ),
              child: FittedBox(
                child: Text(
                  "1",
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 500)],
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
      ],
    );
  }