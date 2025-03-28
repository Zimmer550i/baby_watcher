import 'package:baby_watcher/controllers/user_controller.dart';
import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/show_snackbar.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/overlay_confirmation.dart';
import 'package:baby_watcher/views/screen/common/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Connections extends StatelessWidget {
  const Connections({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>();
    return Scaffold(
      appBar: customAppBar(
        user.userRole == Role.babySitter ? "Connections" : "Manage Connections",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                "You are connected with",
                style: TextStyle(
                  fontVariations: [FontVariation("wght", 600)],
                  fontSize: 20,
                  color: AppColors.indigo,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.indigo[50],
                border: Border.all(color: AppColors.indigo),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ProfilePicture(size: 52, image: user.connectionImage),
                  const SizedBox(width: 12),
                  Text(
                    user.connectionName ?? "Unnamed",
                    style: TextStyle(
                      fontVariations: [FontVariation("wght", 400)],
                      fontSize: 18,
                      color: AppColors.gray,
                    ),
                  ),
                  const Spacer(),
                  if (user.userRole == Role.parent)
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return OverlayConfirmation(
                              title: "Are you sure you want to remove",
                              highlight: "${user.connectionName}?",
                              buttonTextLeft: "Cancel",
                              buttonCallBackLeft: () => Get.back(),
                              buttonTextRight: "Confirm",
                              buttonCallBackRight: () async {
                                final message = await user.deleteConnection();

                                if (message == "Success") {
                                  showSnackBar("Connection Removed");
                                  Get.back();
                                  Get.offNamed(AppRoutes.connections);
                                } else {
                                  showSnackBar(message);
                                }
                              },
                              leftButtonIsSecondary: false,
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.indigo,
                        ),
                        child: Center(
                          child: SvgPicture.asset(AppIcons.editProfile),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
