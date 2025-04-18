import 'package:baby_watcher/controllers/auth_controller.dart';
import 'package:baby_watcher/controllers/user_controller.dart';
import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    user.getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.indigo,
          backgroundColor: AppColors.indigo[25],
          elevation: 0,
          onRefresh: () async {
            await user.getInfo();
            setState(() {
              
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              
              children: [
                const SizedBox(height: 44),
                Center(child: ProfilePicture(image: user.image)),
                SizedBox(height: 29),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    user.userName,
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xff3a3a3a),
                      fontVariations: [FontVariation("wght", 600)],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color(0xffFEFEFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      profileOptions(
                        iconPath: AppIcons.profileInfo,
                        title: "Profile Information",
                        onTap:
                            () => Get.toNamed(AppRoutes.profileInformation),
                      ),
                      if (user.userRole == Role.parent)
                        profileOptions(
                          iconPath: AppIcons.subscription,
                          title: "Subscription",
                          onTap:
                              () => Get.toNamed(AppRoutes.parentSubscription),
                        ),
                      if (user.userRole == Role.parent)
                        profileOptions(
                          iconPath: AppIcons.connection,
                          title: "Manage Connection",
                          onTap: () async {
                            if (user.connectionId.value == null) {
                              Get.toNamed(AppRoutes.parentNotConnected);
                            } else {
                              Get.toNamed(AppRoutes.connections);
                            }
                          },
                        ),
                      if (user.userRole == Role.babySitter)
                        profileOptions(
                          iconPath: AppIcons.connection,
                          title: "Connection",
                          onTap: () => Get.toNamed(AppRoutes.connections),
                        ),
                      profileOptions(
                        iconPath: AppIcons.logout,
                        title: "Log Out",
                        isLast: true,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Color(0xffFFFFFF),
                            builder: (_) {
                              return SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 75),
                                    Text(
                                      "Are you sure you want to",
                                      style: TextStyle(
                                        fontVariations: [
                                          FontVariation("wght", 400),
                                        ],
                                        color: Color(0xff4b4b4b),
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Logout?",
                                      style: TextStyle(
                                        color: AppColors.indigo,
                                        fontSize: 24,
                                        fontVariations: [
                                          FontVariation("wght", 600),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: CustomButton(
                                            text: "Logout",
                                            isSecondary: true,
                                            onTap: () async {
                                              final auth =
                                                  Get.find<AuthController>();
                                              auth.logout();
                                              Get.offAllNamed(
                                                AppRoutes.splashScreen,
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 18),
                                        Expanded(
                                          child: CustomButton(
                                            text: "Cancel",
                                            onTap: () {
                                              Get.back();
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                      ],
                                    ),
                                    const SizedBox(height: 48),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
          
                if (user.userRole == Role.parent &&
                    user.connectionId.value == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Text(
                      "To access all the features connect to a Babysitter from Manage Connection",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontVariations: [FontVariation("wght", 400)],
                        fontSize: 20,
                        color: AppColors.indigo,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector profileOptions({
    required String iconPath,
    required String title,
    Function()? onTap,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          border: Border(
            bottom:
                isLast
                    ? BorderSide.none
                    : BorderSide(width: 0.5, color: AppColors.indigo[200]!),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.indigo[50],
              ),
              child: Center(child: SvgPicture.asset(iconPath)),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontVariations: [FontVariation("wght", 500)],
                fontSize: 18,
                color: AppColors.gray,
              ),
            ),
            const Spacer(),
            SvgPicture.asset(AppIcons.arrowRight),
          ],
        ),
      ),
    );
  }
}
