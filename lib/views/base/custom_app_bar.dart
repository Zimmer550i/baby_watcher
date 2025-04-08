import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

AppBar customAppBar(
  String title, {
  bool showBackButton = true,
  List<Widget> actions = const [],
  Function()? callBack,
}) {
  return AppBar(
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
        fontVariations: [FontVariation("wght", 400)],
        fontSize: 16,
        color: AppColors.gray[800],
      ),
    ),
    backgroundColor: AppColors.indigo[25],
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    bottom: PreferredSize(
      preferredSize: Size(double.infinity, 0),
      child: Container(height: 1, color: AppColors.indigo[100]),
    ),
    leading:
        showBackButton
            ? InkWell(
              borderRadius: BorderRadius.circular(99),
              onTap: () {
                if (callBack != null) {
                  callBack();
                }
                Get.back();
              },
              child: Center(child: SvgPicture.asset(AppIcons.arrowLeft)),
            )
            : null,
    actions: actions,
  );
}
