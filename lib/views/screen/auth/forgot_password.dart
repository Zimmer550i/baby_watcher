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

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Forgot Password"),
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
                  "Forgot Password ?",
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 600)],
                    fontSize: 24,
                    color: AppColors.indigo,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Please enter your email address to reset your password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 400)],
                    fontSize: 16,
                    color: AppColors.gray,
                  ),
                ),
                const SizedBox(height: 28),
                CustomTextField(
                  leading: AppIcons.email,
                  hintText: "Enter Email",
                  controller: emailController,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: "Send OTP",
                  isLoading: isLoading,
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      final auth = Get.find<AuthController>();
                      final user = Get.find<UserController>();

                      user.userEmail = emailController.text.trim();

                      final message = await auth.forgotPassword(
                        emailController.text.trim(),
                      );

                      if (message == "Success") {
                        Get.toNamed(AppRoutes.otpVerification);
                      } else {
                        showSnackBar(message);
                      }
                    } catch (e) {
                      showSnackBar(e.toString());
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
