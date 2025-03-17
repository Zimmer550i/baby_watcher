import 'package:baby_watcher/controllers/auth_controller.dart';
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

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool isLoading = false;
  TextEditingController first = TextEditingController();
  TextEditingController second = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Reset Password"),
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  "Reset Password",
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 600)],
                    fontSize: 24,
                    color: AppColors.indigo,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Create a new Password for your account.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 400)],
                    fontSize: 16,
                    color: AppColors.gray,
                  ),
                ),
                const SizedBox(height: 28),
                CustomTextField(
                  isPassword: true,
                  hintText: "Enter Password",
                  controller: first,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  isPassword: true,
                  hintText: "Re-Enter Password",
                  controller: second,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: "Confirm",
                  isLoading: isLoading,
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      final auth = Get.find<AuthController>();

                      final message = await auth.resetPassword(
                        first.text.trim(),
                        second.text.trim(),
                        Get.parameters['Authorization']!,
                      );

                      if (message == "Success") {
                        Get.until(
                          (route) => route.settings.name == AppRoutes.signIn,
                        );
                        showSnackBar(
                          "Reset Password Successfull",
                          isError: false,
                        );
                      }
                    } catch (e) {
                      showSnackBar(e.toString());
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
