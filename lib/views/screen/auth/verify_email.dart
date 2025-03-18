import 'package:baby_watcher/controllers/auth_controller.dart';
import 'package:baby_watcher/controllers/user_controller.dart';
import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/show_snackbar.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "Verify Your Email",
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 600)],
                    fontSize: 24,
                    color: AppColors.indigo,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Please enter the OTP code, We’ve sent you in your mail",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 400)],
                    fontSize: 16,
                    color: AppColors.gray,
                  ),
                ),
                const SizedBox(height: 28),
                Pinput(
                  length: 6,
                  controller: otpController,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  onCompleted: (value) {},
                  defaultPinTheme: PinTheme(
                    height: 48,
                    width: 48,
                    textStyle: TextStyle(
                      fontVariations: [FontVariation("wght", 400)],
                      fontSize: 18,
                      color: AppColors.gray,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        width: 0.5,
                        color: AppColors.indigo.shade400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: "Verify",
                  isLoading: isLoading,
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    final user = Get.find<UserController>();
                    try {
                      final auth = Get.find<AuthController>();
                      var message = await auth.verifyEmail(
                        otpController.text.trim(),
                      );
                      if (message == "Success") {
                        if (user.userRole == Role.parent) {
                          Get.offAllNamed(AppRoutes.parentApp);
                        } else if (user.userRole == Role.babySitter) {
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
                      "Don’t get the code?",
                      style: TextStyle(
                        fontVariations: [FontVariation("wght", 400)],
                        fontSize: 12,
                        color: AppColors.gray.shade400,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          final auth = Get.find<AuthController>();

                          if (await auth.sendOtp()) {
                            showSnackBar(
                              "Verification email sent",
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
                      child: Text(
                        " Resend ",
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
        ),
      ),
    );
  }
}
