import 'package:baby_watcher/controllers/user_controller.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/show_snackbar.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ParentNotConnected extends StatelessWidget {
  const ParentNotConnected({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        "Manage Connections",
        callBack: () => Get.find<UserController>().getInfo(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Spacer(flex: 18),
            SvgPicture.asset(AppIcons.logo),
            const SizedBox(height: 28),
            Text(
              "Currently, you are not connected with any babysitter",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontVariations: [FontVariation("wght", 400)],
                fontSize: 18,
                color: AppColors.gray,
              ),
            ),
            const SizedBox(height: 28),
            CustomTextField(
              isDisabled: true,
              trailing: AppIcons.copy,
              onTap: () {
                final text =
                    Get.find<UserController>().uniqueKey ?? "Not Available";
                Clipboard.setData(ClipboardData(text: text));
                // Optional: show a snackbar or toast
                showSnackBar("Copied to clipboard", isError: false);
              },
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: Get.find<UserController>().uniqueKey ?? "Not Available",
                ),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "**Share this key with your babysitter to connect",
                style: TextStyle(
                  fontVariations: [FontVariation("wght", 400)],
                  fontSize: 12,
                  color: AppColors.indigo,
                ),
              ),
            ),
            const Spacer(flex: 29),
          ],
        ),
      ),
    );
  }
}
