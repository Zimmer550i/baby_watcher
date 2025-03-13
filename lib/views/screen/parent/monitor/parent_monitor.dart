import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/home_app_bar.dart';
import 'package:baby_watcher/views/base/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ParentMonitor extends StatefulWidget {
  const ParentMonitor({super.key});

  @override
  State<ParentMonitor> createState() => _ParentMonitorState();
}

class _ParentMonitorState extends State<ParentMonitor> {
  bool babySleeping = true;
  bool reqSent = false;

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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          babySleeping ? "Baby is sleeping" : "Baby is awake",
                          style: TextStyle(
                            fontVariations: [FontVariation("wght", 600)],
                            fontSize: 20,
                            color: AppColors.indigo[700],
                          ),
                        ),
                        Text(
                          babySleeping
                              ? "Since 3:10 PM"
                              : "Awake since 3:10 PM",
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
                      "Total: 7h 21m",
                      style: TextStyle(
                        fontVariations: [FontVariation("wght", 400)],
                        fontSize: 12,
                        color: AppColors.indigo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      babySleeping = !babySleeping;
                    });
                  },
                  child: SvgPicture.asset(
                    babySleeping ? AppIcons.babyAsleep : AppIcons.babyAwake,
                  ),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: reqSent ? "Request Sent" : "Request Instant Video",
                  leading: reqSent ? AppIcons.tickCircle : AppIcons.video,
                  radius: 8,
                  isSecondary: reqSent,
                  onTap: () {
                    setState(() {
                      reqSent = !reqSent;
                    });
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
                            "1",
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

                VideoWidget(
                  url:
                      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                  thumbnail: "assets/images/baby_1.png",
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
                    VideoWidget(
                      url:
                          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                      thumbnail: "assets/images/baby_2.png",
                    ),
                    VideoWidget(
                      url:
                          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                      thumbnail: "assets/images/baby_3.png",
                    ),
                    VideoWidget(
                      url:
                          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                      thumbnail: "assets/images/baby_4.png",
                    ),
                    VideoWidget(
                      url:
                          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                      thumbnail: "assets/images/baby_5.png",
                    ),
                    VideoWidget(
                      url:
                          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                      thumbnail: "assets/images/baby_6.png",
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
