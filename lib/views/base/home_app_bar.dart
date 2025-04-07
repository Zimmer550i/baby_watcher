import 'package:baby_watcher/controllers/socket_controller.dart';
import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

AppBar homeAppBar() {
  final controller = Get.find<SocketController>();
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
      InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.notifications);
        },
        borderRadius: BorderRadius.circular(90),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              SvgPicture.asset(AppIcons.notification),
              Obx(() {
                if (controller.unreadNotifications > 0) {
                  return Container(
                    height: 14,
                    width: 14,
                    decoration: BoxDecoration(
                      color: AppColors.indigo,
                      shape: BoxShape.circle,
                    ),
                    child: FittedBox(
                      child: Text(
                        controller.unreadNotifications.string,
                        style: TextStyle(
                          fontVariations: [FontVariation("wght", 500)],
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
            ],
          ),
        ),
      ),
      const SizedBox(width: 16),
    ],
  );
}
