import 'package:baby_watcher/controllers/emergency_controller.dart';
import 'package:baby_watcher/models/contact_model.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/show_snackbar.dart';
import 'package:baby_watcher/views/base/custom_app_bar.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/custom_text_field.dart';
import 'package:baby_watcher/views/base/overlay_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentEditContact extends StatefulWidget {
  final ContactModel contact;
  const ParentEditContact(this.contact, {super.key});

  @override
  State<ParentEditContact> createState() => _ParentEditContactState();
}

class _ParentEditContactState extends State<ParentEditContact> {
  final emergencyController = Get.find<EmergencyController>();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.contact.name;
    phoneController.text = widget.contact.phone;
  }

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
              controller: nameController,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              leading: AppIcons.phone,
              hintText: "Emergency Contact",
              controller: phoneController,
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
                              buttonCallBackRight: () async {
                                final response = await emergencyController
                                    .deleteContact(widget.contact.id);

                                if (response == "Success") {
                                  emergencyController.contacts.remove(
                                    widget.contact,
                                  );
                                  Get.back();
                                  Get.back();
                                  showSnackBar(
                                    "Contact deleted successfully",
                                    isError: false,
                                  );
                                } else {
                                  showSnackBar(response);
                                }
                              },
                              leftButtonIsSecondary: false,
                            ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomButton(
                    text: "Save",
                    onTap: () async {
                      Map<String, String> data = {};
                      if (nameController.text.trim() != widget.contact.name) {
                        data.addAll({"name": nameController.text.trim()});
                      }
                      if (phoneController.text.trim() != widget.contact.phone) {
                        data.addAll({"name": phoneController.text.trim()});
                      }
                      final message = await emergencyController.updateContact(
                        widget.contact.id,
                        data,
                      );

                      if (message == "Success") {
                        await emergencyController.getParentContact();

                        Get.back();
                        showSnackBar(
                          "Contact edited successfully",
                          isError: false,
                        );
                      } else {
                        showSnackBar(message);
                      }
                    },
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
