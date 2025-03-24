import 'package:baby_watcher/controllers/auth_controller.dart';
import 'package:baby_watcher/controllers/user_controller.dart';
import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/show_snackbar.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ConnectMothersAccount extends StatefulWidget {
  const ConnectMothersAccount({super.key});

  @override
  State<ConnectMothersAccount> createState() => _ConnectMothersAccountState();
}

class _ConnectMothersAccountState extends State<ConnectMothersAccount> {
  final TextEditingController keyController = TextEditingController();
  final user = Get.find<UserController>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        "",
        showBackButton: false,
        actions: [
          TextButton(
            onPressed: () async {
              bool? confirmLogout = await showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        "Confirm Logout",
                        style: TextStyle(
                          fontVariations: [FontVariation("wght", 600)],
                          fontSize: 24,
                          color: AppColors.indigo,
                        ),
                      ),
                      content: Text(
                        "Are you sure you want to log out?",
                        style: TextStyle(
                          fontVariations: [FontVariation("wght", 400)],
                          fontSize: 16,
                          color: AppColors.gray,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontVariations: [FontVariation("wght", 400)],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              fontVariations: [FontVariation("wght", 400)],
                            ),
                          ),
                        ),
                      ],
                    ),
              );

              if (confirmLogout == true) {
                final auth = Get.find<AuthController>();
                await auth.logout();
                Get.offAllNamed(AppRoutes.welcome);
              }
            },
            child: Text(
              "Logout",
              style: TextStyle(fontVariations: [FontVariation("wght", 400)]),
            ),
          ),
        ],
      ),
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
                  controller: keyController,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: "Connect",
                  isLoading: isLoading,
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    final message = await user.connectToMother(
                      keyController.text.trim(),
                    );

                    if (message == "Success") {
                      showSnackBar(
                        "Connected to mother's account successfully",
                        isError: false,
                      );
                      Get.offNamed(AppRoutes.babysitterApp);
                    } else {
                      showSnackBar(message);
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
