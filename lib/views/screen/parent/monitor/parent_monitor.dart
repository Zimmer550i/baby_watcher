import 'package:baby_watcher/controllers/monitor_controller.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/formatter.dart';
import 'package:baby_watcher/utils/show_snackbar.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/home_app_bar.dart';
import 'package:baby_watcher/views/base/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ParentMonitor extends StatefulWidget {
  const ParentMonitor({super.key});

  @override
  State<ParentMonitor> createState() => _ParentMonitorState();
}

class _ParentMonitorState extends State<ParentMonitor> {
  final monitorController = Get.find<MonitorController>();
  bool babySleeping = true;
  bool reqSent = false;

  @override
  void initState() {
    super.initState();
    monitorController.getVideos();
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
                Obx(
                  () => Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            monitorController.sleepingSince.value != null
                                ? "Baby is sleeping"
                                : "Baby is awake",
                            style: TextStyle(
                              fontVariations: [FontVariation("wght", 600)],
                              fontSize: 20,
                              color: AppColors.indigo[700],
                            ),
                          ),
                          Text(
                            monitorController.sleepingSince.value != null
                                ? "Since ${Formatter.timeFormatter(dateTime: monitorController.sleepingSince.value)}"
                                : "",
                            style: TextStyle(
                              fontVariations: [FontVariation("wght", 400)],
                              fontSize: 14,
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        "Total: ${monitorController.getTotalSleep()}",
                        style: TextStyle(
                          fontVariations: [FontVariation("wght", 400)],
                          fontSize: 12,
                          color: AppColors.indigo,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => SvgPicture.asset(
                    monitorController.sleepingSince.value != null
                        ? AppIcons.babyAsleep
                        : AppIcons.babyAwake,
                  ),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: reqSent ? "Request Sent" : "Request Instant Video",
                  leading: reqSent ? AppIcons.tickCircle : AppIcons.video,
                  radius: 8,
                  isSecondary: reqSent,
                  onTap: () async {
                    final response = await monitorController.sendRequest();
                    if (response == "Success") {
                      setState(() {
                        reqSent = !reqSent;
                      });
                    } else {
                      showSnackBar(response);
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 16),
                  child: Row(
                    children: [
                      Text(
                        "New Video",
                        style: TextStyle(
                          fontVariations: [FontVariation("wght", 400)],
                          fontSize: 14,
                          color: AppColors.gray,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: AppColors.indigo[50],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            monitorController.unseenVideos.value.toString(),
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

                for (var i in monitorController.videos)
                  if (!i.isSeen)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: VideoWidget(
                        url: i.video,
                        thumbnail: "assets/images/baby_1.png",
                      ),
                    ),
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 16),
                  child: Row(
                    children: [
                      Text(
                        "Previous Videos",
                        style: TextStyle(
                          fontVariations: [FontVariation("wght", 400)],
                          fontSize: 14,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                ),

                GridView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  children: [
                    for (var i in monitorController.videos)
                      if (i.isSeen)
                        VideoWidget(
                          url: i.video,
                          thumbnail: "assets/images/baby_1.png",
                        ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
