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
  final scrollController = ScrollController();
  final monitorController = Get.find<MonitorController>();
  bool babySleeping = true;
  bool reqSent = false;

  @override
  void initState() {
    super.initState();
    // Set up scroll listener for refresh logic
    scrollController.addListener(() {
      if (monitorController.loadingVideos.value ||
          !monitorController.loadMoreVideo) {
        return;
      }
      final position = scrollController.position;
      final maxScroll = position.maxScrollExtent;
      final currentScroll = position.pixels;

      // Trigger load more if near the bottom
      if (!position.hasPixels ||
          maxScroll == 0 ||
          currentScroll >= maxScroll - 50) {
        monitorController.getMoreVideos();
      }
    });

    // Check after the first frame if the content is not scrollable
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await monitorController.getVideos();
      final position = scrollController.position;
      if (position.maxScrollExtent == 0 && monitorController.loadMoreVideo) {
        monitorController.getMoreVideos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          controller: scrollController,
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
                            monitorController.isAwake.value
                                ? "Baby is awake"
                                : "Baby is sleeping",
                            style: TextStyle(
                              fontVariations: [FontVariation("wght", 600)],
                              fontSize: 20,
                              color: AppColors.indigo[700],
                            ),
                          ),
                          Text(
                            monitorController.sleepingSince.value == null
                                ? ""
                                : "Since ${Formatter.timeFormatter(dateTime: monitorController.sleepingSince.value)}",
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
                    monitorController.isAwake.value
                        ? AppIcons.babyAwake
                        : AppIcons.babyAsleep,
                  ),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: reqSent ? "Request Sent" : "Request Instant Video",
                  leading: reqSent ? AppIcons.tickCircle : AppIcons.video,
                  radius: 8,
                  isSecondary: reqSent,
                  onTap: () async {
                    if (reqSent) {
                      return;
                    }
                    final response = await monitorController.sendRequest();
                    if (response == "Success") {
                      setState(() {
                        reqSent = !reqSent;
                      });
                    } else if (response == "Subscription not found") {
                      showSnackBar("Need subscription for this feature");
                    } else {
                      showSnackBar(response);
                    }
                  },
                ),
                Obx(() {
                  if (monitorController.unseenVideos.value == 0) {
                    return Container();
                  }
                  return Padding(
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
                  );
                }),

                Obx(
                  () => Column(
                    children: [
                      for (var i in monitorController.videos)
                        if (!i.isSeen)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: VideoWidget(
                              url: i.video,
                              thumbnail: i.thumbnail,
                              id: i.id,
                            ),
                          ),
                    ],
                  ),
                ),
                Obx(() {
                  if (monitorController.videos.length ==
                      monitorController.unseenVideos.value) {
                    return Container();
                  }
                  return Padding(
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
                  );
                }),

                Obx(
                  () => GridView(
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
                            thumbnail: i.thumbnail,
                            id: i.id,
                          ),
                    ],
                  ),
                ),
                if (monitorController.loadingVideos.value)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
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
