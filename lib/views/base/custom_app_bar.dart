  import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

AppBar customAppBar(String title) {
    return AppBar(
      centerTitle: true,
      title: Text(title,
      style: TextStyle(
        fontVariations: [FontVariation("wght", 400)],
        fontSize: 16,
        color: AppColors.gray[800]
      ),),
      backgroundColor: AppColors.indigo[25],
      bottom: PreferredSize(
        preferredSize: Size(double.infinity, 1),
        child: Divider(color: AppColors.indigo[100]),
      ),
      leading: InkWell(
        borderRadius: BorderRadius.circular(99),
        onTap: () {
          Get.back();
        },
        child: Center(child: SvgPicture.asset(AppIcons.arrowLeft)),
      ),
    );
  }