import 'package:baby_watcher/controllers/auth_controller.dart';
import 'package:baby_watcher/controllers/user_controller.dart';
import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/show_snackbar.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
            const SizedBox(height: 28),
            CustomTextField(
              leading: AppIcons.email,
              hintText: "Email",
              controller: emailController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              isPassword: true,
              hintText: "Password",
              controller: passController,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  final user = Get.find<UserController>();
                  user.userEmail = emailController.text.trim();
                  Get.toNamed(AppRoutes.forgotPassword);
                },
                child: Text(
                  " Forget Password ",
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 400)],
                    fontSize: 12,
                    color: AppColors.indigo,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 36),
            CustomButton(
              text: "Login",
              isLoading: isLoading,
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                try {
                  final authController = Get.find<AuthController>();
                  final userController = Get.find<UserController>();
                  var message = await authController.login(
                    emailController.text.trim(),
                    passController.text.trim(),
                  );

                  if (message ==
                      "Please verify your account, then try to login again") {
                    userController.userEmail = emailController.text.trim();
                    authController.sendOtp();
                    Get.toNamed(AppRoutes.verifyEmail);
                  } else if (message == "Success") {
                    if (userController.userRole == Role.parent) {
                      Get.offAllNamed(AppRoutes.parentApp);
                    } else {
                      Get.offAllNamed(AppRoutes.babysitterApp);
                    }
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
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 400)],
                    fontSize: 12,
                    color: AppColors.gray.shade400,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Get.offNamed(AppRoutes.roleSelect);
                  },
                  child: Text(
                    " SignUp ",
                    style: TextStyle(
                      fontVariations: [FontVariation("wght", 400)],
                      fontSize: 12,
                      color: AppColors.indigo,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
