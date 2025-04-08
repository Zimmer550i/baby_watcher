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

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final nameCntrl = TextEditingController();
  final emailCntrl = TextEditingController();
  final phoneCntrl = TextEditingController();
  final passCntrl = TextEditingController();
  final confirmPassCntrl = TextEditingController();
  bool isValidEmail = true;
  bool isValidPassword = true;
  bool isLoading = false;

  void _validateInputs() {
    final emailPattern = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    final passwordPattern = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

    setState(() {
      isValidEmail = emailPattern.hasMatch(emailCntrl.text);
      isValidPassword =
          passwordPattern.hasMatch(passCntrl.text.trim()) &&
          passCntrl.text.trim() == confirmPassCntrl.text.trim();
    });
  }

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
              leading: AppIcons.user,
              hintText: "Name",
              controller: nameCntrl,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              leading: AppIcons.email,
              hintText: "Email",
              controller: emailCntrl,
              errorText: isValidEmail ? null : "Invalid email format",
            ),
            const SizedBox(height: 16),
            CustomTextField(
              leading: AppIcons.phone,
              hintText: "Phone Number",
              controller: phoneCntrl,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              isPassword: true,
              hintText: "Password",
              controller: passCntrl,
              errorText:
                  isValidPassword
                      ? null
                      : "Password must be at least 8 characters, include letters and numbers",
            ),
            const SizedBox(height: 16),
            CustomTextField(
              isPassword: true,
              hintText: "Confirm Password",
              controller: confirmPassCntrl,
              errorText: isValidPassword ? null : "Passwords do not match",
            ),
            const SizedBox(height: 36),
            CustomButton(
              text: "Signup",
              isLoading: isLoading,
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                try {
                  _validateInputs();
                  if (isValidEmail && isValidPassword) {
                    final auth = Get.find<AuthController>();
                    final user = Get.find<UserController>();

                    var message = await auth.signup({
                      "name": nameCntrl.text.trim(),
                      "email": emailCntrl.text.trim(),
                      "password": passCntrl.text.trim(),
                      "phone": phoneCntrl.text.trim(),
                    });
                    if (message == "Success") {
                      user.userEmail = emailCntrl.text.trim();
                      user.userName = nameCntrl.text.trim();
                      user.userPhone = phoneCntrl.text.trim();
                      Get.toNamed(AppRoutes.verifyEmail);
                    } else {
                      showSnackBar(message);
                    }
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
                  "Already have an account?",
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 400)],
                    fontSize: 12,
                    color: AppColors.gray.shade400,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Get.offNamed(AppRoutes.signIn);
                  },
                  child: Text(
                    " Log In ",
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
