import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/custom_text_field.dart';
import 'package:baby_watcher/views/base/overlay_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ParentEditContact extends StatelessWidget {
  const ParentEditContact({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Edit Emergency Contact"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            CustomTextField(
              leading: AppIcons.person,
              hintText: "Enter Name",
              controller: TextEditingController(text: "Albert Flores"),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              leading: AppIcons.phone,
              hintText: "Emergency Contact",
              controller: TextEditingController(text: "0123456787911"),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Delete",
                    isSecondary: true,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => OverlayConfirmation(
                              title:
                                  "Are you sure you want to remove this emergency contact?",
                              buttonTextLeft: "Cancel",
                              buttonCallBackLeft: () {
                                Get.back();
                              },
                              buttonTextRight: "Confirm",
                              buttonCallBackRight: () {
                                Get.back();
                                Get.back();
                              },
                              leftButtonIsSecondary: false,
                            ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(child: CustomButton(text: "Save")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
