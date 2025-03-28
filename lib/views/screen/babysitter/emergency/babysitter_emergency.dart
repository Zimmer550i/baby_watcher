import 'package:baby_watcher/controllers/emergency_controller.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/formatter.dart';
import 'package:baby_watcher/utils/show_snackbar.dart';
import 'package:baby_watcher/views/base/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BabysitterEmergency extends StatefulWidget {
  const BabysitterEmergency({super.key});

  @override
  State<BabysitterEmergency> createState() => _BabysitterEmergencyState();
}

class _BabysitterEmergencyState extends State<BabysitterEmergency> {
  final emergencyController = Get.find<EmergencyController>();
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emergencyController.getParentContact().then((onValue) {
      setState(() {});
    });
  }

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
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    alertMenu(context);
                  },
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.indigo,
                    ),
                    child: Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppIcons.alarm,
                          height: 24,
                          width: 24,
                          colorFilter: ColorFilter.mode(
                            AppColors.indigo[25]!,
                            BlendMode.srcIn,
                          ),
                        ),
                        Text(
                          "Send An Emergency Alert",
                          style: TextStyle(
                            fontVariations: [FontVariation("wght", 600)],
                            fontSize: 18,
                            color: AppColors.indigo[25],
                          ),
                        ),
                      ],
                    ),
                  ),
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
                      ...emergencyController.contacts.map((e) {
                        return GestureDetector(
                          child: Container(
                            height: 78,
                            decoration: BoxDecoration(
                              border:
                                  emergencyController.contacts.last != e
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
                                    launchUrl(Uri.parse("tel:${e.phone}"));
                                  },
                                  child: SvgPicture.asset(
                                    AppIcons.phone,
                                    height: 24,
                                    width: 24,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.gray[600]!,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> alertMenu(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(16),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                        color: AppColors.indigo[200]!,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(99),
                        onTap: () {
                          Get.back();
                        },

                        child: SvgPicture.asset(AppIcons.arrowLeft),
                      ),
                      Text(
                        "Select Emergency Alert",
                        style: TextStyle(
                          fontVariations: [FontVariation("wght", 400)],
                          fontSize: 16,
                          color: AppColors.gray[800],
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                ),
                ...[
                  "Health Emergency",
                  "Safety Concern",
                  "Accident",
                  "Child in Distress",
                  "Injury",
                ].map((e) {
                  return GestureDetector(
                    onTap: () async {
                      String alert =
                          "Baby Sitter has reported a${['a', 'e', 'i', 'o', 'u'].contains(e[0].toLowerCase()) ? "n" : ""} $e at ${Formatter.timeFormatter(dateTime: DateTime.now())}";
                      final message = await emergencyController
                          .sendEmergencyAlert(alert);

                      if (message == "Success") {
                        showSnackBar(
                          "Emergency alert sent to Parent",
                          isError: false,
                        );
                        Get.back();
                      } else {
                        showSnackBar(message);
                        Get.back();
                      }
                    },
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color: AppColors.indigo[200]!,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            e,
                            style: TextStyle(
                              fontVariations: [FontVariation("wght", 400)],
                              fontSize: 16,
                              color: AppColors.gray,
                            ),
                          ),
                          const Spacer(),
                          SvgPicture.asset(AppIcons.sendRight),
                        ],
                      ),
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.indigo[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.only(left: 8, top: 4, bottom: 8),
                          child: TextField(
                            controller: textController,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: "Anything else...",
                              hintStyle: TextStyle(
                                fontVariations: [FontVariation("wght", 400)],
                                fontSize: 12,
                                color: AppColors.gray,
                                height: 0.5,
                              ),
                              contentPadding: EdgeInsets.all(0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () async {
                          String alert =
                              "Baby Sitter has reported a${['a', 'e', 'i', 'o', 'u'].contains(textController.text[0].toLowerCase()) ? "n" : ""} ${textController.text} at ${Formatter.timeFormatter(dateTime: DateTime.now())}";
                          final message = await emergencyController
                              .sendEmergencyAlert(alert);

                          if (message == "Success") {
                            showSnackBar(
                              "Emergency alert sent to Parent",
                              isError: false,
                            );
                            Get.back();
                          } else {
                            showSnackBar(message);
                            Get.back();
                          }
                        },
                        child: SvgPicture.asset(AppIcons.sendRight),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 68,
                //   child: Row(children: [
                //     Container(
                //       child: TextField(

                //       ),
                //     )
                //   ],),
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}
