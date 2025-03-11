import 'package:baby_watcher/helpers/route.dart';
import 'package:baby_watcher/models/contact_model.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class ParentEmergency extends StatefulWidget {
  const ParentEmergency({super.key});

  @override
  State<ParentEmergency> createState() => _ParentEmergencyState();
}

class _ParentEmergencyState extends State<ParentEmergency> {
  List<String> data = [
    "Babysitter reports a health emergency with the baby",
    "Babysitter reports an accident with the baby",
  ];
  List<ContactModel> contacts = [
    ContactModel("Albert Flores", "012345678911"),
    ContactModel("Darrell Steward", "012345678911"),
    ContactModel("Jerome Bell", "012345678911"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(),
      body: Align(
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
                      if (data.isNotEmpty)
                        Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: AppColors.indigo[50],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              data.length.toString(),
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

                if (data.isEmpty)
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

                ...data.map((e) {
                  return Column(
                    spacing: 4,
                    children: [
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              data.removeAt(data.indexOf(e));
                            });
                          },
                          child: SvgPicture.asset(AppIcons.close),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          e,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontVariations: [FontVariation("wght", 500)],
                            fontSize: 24,
                            color: AppColors.indigo[700],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (data.indexOf(e) != data.length - 1)
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: AppColors.indigo[100],
                        ),
                    ],
                  );
                }),

                if (data.isNotEmpty)
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
                      ...contacts.map((e) {
                        return GestureDetector(
                          child: Container(
                            height: 78,
                            decoration: BoxDecoration(
                              border:
                                  contacts.last != e
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      e.name,
                                      style: TextStyle(
                                        fontVariations: [
                                          FontVariation("wght", 400),
                                        ],
                                        fontSize: 12,
                                        color: AppColors.gray,
                                      ),
                                    ),
                                    Text(
                                      e.phone,
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
                                    Get.toNamed(AppRoutes.parentEditContact);
                                  },
                                  child: SvgPicture.asset(AppIcons.edit),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
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
    );
  }
}
