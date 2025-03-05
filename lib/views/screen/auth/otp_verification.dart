import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpVerification extends StatelessWidget {
  const OtpVerification({super.key});

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
                  length: 5,
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
                  onTap: () {
                    Get.toNamed(AppRoutes.resetPasword);
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
                      onTap: () {},
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
