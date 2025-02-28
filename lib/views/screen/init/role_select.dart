import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RoleSelect extends StatefulWidget {
  const RoleSelect({super.key});

  @override
  State<RoleSelect> createState() => _RoleSelectState();
}

class _RoleSelectState extends State<RoleSelect> {
  int selected = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Spacer(),
            Text(
              "Choose Your Role In Baby Watcher App",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontVariations: [FontVariation("wght", 600)],
                fontSize: 24,
                color: AppColors.gray[500],
              ),
            ),
            const SizedBox(height: 46),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selected == 0) {
                        selected = -1;
                      } else {
                        selected = 0;
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.indigo[selected == 0 ? 100 : 50],
                      borderRadius: BorderRadius.circular(8),
                      border:
                          selected == 0
                              ? Border.all(width: 2, color: AppColors.indigo)
                              : Border.all(width: 2, color: Colors.transparent),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset(AppIcons.parent),
                        Text(
                          "Parent",
                          style: TextStyle(
                            fontVariations: [FontVariation("wght", 500)],
                            fontSize: 18,
                            color: AppColors.gray[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selected == 1) {
                        selected = -1;
                      } else {
                        selected = 1;
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.indigo[selected == 1 ? 100 : 50],
                      borderRadius: BorderRadius.circular(8),
                      border:
                          selected == 1
                              ? Border.all(width: 2, color: AppColors.indigo)
                              : Border.all(width: 2, color: Colors.transparent),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset(AppIcons.babySitter),
                        Text(
                          "Baby Sitter",
                          style: TextStyle(
                            fontVariations: [FontVariation("wght", 500)],
                            fontSize: 18,
                            color: AppColors.gray[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            CustomButton(
              text: "Continue",
              isDisabled: selected == -1,
              onTap: () {
                if (selected != -1) {
                  Get.toNamed(AppRoutes.signUp);
                }
              },
            ),
            SafeArea(child: const SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
