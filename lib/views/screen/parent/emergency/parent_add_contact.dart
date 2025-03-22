import 'package:baby_watcher/controllers/emergency_controller.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/show_snackbar.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentAddContact extends StatefulWidget {
  const ParentAddContact({super.key});

  @override
  State<ParentAddContact> createState() => _ParentAddContactState();
}

class _ParentAddContactState extends State<ParentAddContact> {
  final emergencyController = Get.find<EmergencyController>();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Add Emergency Contact"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            CustomTextField(
              leading: AppIcons.person,
              hintText: "Enter Name",
              controller: nameController,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              leading: AppIcons.phone,
              hintText: "Emergency Contact",
              controller: phoneController,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: "Add",
              width: null,
              padding: 65,
              isLoading: emergencyController.isLoading.value,
              onTap: () async {
                final message = await emergencyController.createContact(
                  nameController.text.trim(),
                  phoneController.text.trim(),
                );

                if (message == "Success") {
                  emergencyController.getParentContact();
                  Get.back();
                  showSnackBar("Contact added successfully", isError: false);
                } else {
                  showSnackBar(message);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
