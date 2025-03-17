import 'package:baby_watcher/controllers/auth_controller.dart';
import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/show_snackbar.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  bool isLoading = false;
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Otp Verification"),
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
                  "OTP Verification",
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
                    if (otpController.text.isEmpty) {
                      showSnackBar("Enter an OTP Code");
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      final auth = Get.find<AuthController>();

                      final message = await auth.verifyEmail(
                        otpController.text.trim(),
                        isResetingPassword: true
                      );

                      if (message.contains("Success")) {
                        Get.toNamed(AppRoutes.resetPasword, parameters: {"Authorization": message.substring(8)});
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
