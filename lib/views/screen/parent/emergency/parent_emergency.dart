import 'package:baby_watcher/controllers/emergency_controller.dart';
import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/models/contact_model.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/home_app_bar.dart';
import 'package:baby_watcher/views/screen/parent/emergency/parent_edit_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ParentEmergency extends StatefulWidget {
  const ParentEmergency({super.key});

  @override
  State<ParentEmergency> createState() => _ParentEmergencyState();
}

class _ParentEmergencyState extends State<ParentEmergency> {
  final emergencyController = Get.find<EmergencyController>();
  List<String> data = [];
  List<ContactModel> contacts = [];

  @override
  void initState() {
    super.initState();
    emergencyController.getParentContact();
    emergencyController.getAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(),
      body: Obx(
        () => Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 16),
                    child: Row(
                      spacing: 4,
                      children: [
                        Text(
                          "Emergency Alert",
                          style: TextStyle(
                            fontVariations: [FontVariation("wght", 400)],
                            fontSize: 14,
                            color: AppColors.gray,
                          ),
                        ),
                        if (emergencyController.alerts.isNotEmpty)
                          Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: AppColors.indigo[50],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                emergencyController.alerts.length.toString(),
                                style: TextStyle(
                                  fontVariations: [FontVariation("wght", 600)],
                                  fontSize: 12,
                                  color: AppColors.indigo,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  if (emergencyController.alerts.isEmpty)
                    Column(
                      children: [
                        Text(
                          "No emergencies at the moment. Stay calm and connected.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontVariations: [FontVariation("wght", 500)],
                            fontSize: 24,
                            color: AppColors.indigo[700],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SvgPicture.asset(AppIcons.safe),
                      ],
                    ),

                  for (
                    int i = 0;
                    i < emergencyController.alerts.length;
                    i++
                  ) ...[
                    Column(
                      spacing: 4,
                      children: [
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              emergencyController.deleteAlert(i);
                            },
                            child: SvgPicture.asset(AppIcons.close),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            emergencyController.alerts[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontVariations: [FontVariation("wght", 500)],
                              fontSize: 24,
                              color: AppColors.indigo[700],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (i != emergencyController.alerts.length - 1)
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: AppColors.indigo[100],
                          ),
                      ],
                    ),
                  ],

                  if (emergencyController.alerts.isNotEmpty)
                    CustomButton(
                      text: "Call Babysitter",
                      leading: AppIcons.phone,
                      width: null,
                      onTap: () {
                        launchUrl(Uri.parse("tel:023421"));
                      },
                    ),

                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 16),
                    child: Row(
                      children: [
                        Text(
                          "Emergency Contacts",
                          style: TextStyle(
                            fontVariations: [FontVariation("wght", 400)],
                            fontSize: 14,
                            color: AppColors.gray,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Color(0xffFEFEFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        for (
                          int i = 0;
                          i < emergencyController.contacts.length;
                          i++
                        ) ...[
                          GestureDetector(
                            child: Container(
                              height: 78,
                              decoration: BoxDecoration(
                                border:
                                    i != emergencyController.contacts.length - 1
                                        ? Border(
                                          bottom: BorderSide(
                                            width: 0.5,
                                            color: AppColors.indigo[200]!,
                                          ),
                                        )
                                        : null,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.indigo[50],
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(AppIcons.person),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        emergencyController.contacts
                                            .elementAt(i)
                                            .name,
                                        style: TextStyle(
                                          fontVariations: [
                                            FontVariation("wght", 400),
                                          ],
                                          fontSize: 12,
                                          color: AppColors.gray,
                                        ),
                                      ),
                                      Text(
                                        emergencyController.contacts
                                            .elementAt(i)
                                            .phone,
                                        style: TextStyle(
                                          fontVariations: [
                                            FontVariation("wght", 500),
                                          ],
                                          fontSize: 18,
                                          color: AppColors.gray,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => ParentEditContact(
                                          emergencyController.contacts
                                              .elementAt(i),
                                        ),
                                      );
                                    },
                                    child: SvgPicture.asset(AppIcons.edit),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Add Contact",
                    width: null,
                    leading: AppIcons.add,
                    onTap: () {
                      Get.toNamed(AppRoutes.parentAddContact);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
