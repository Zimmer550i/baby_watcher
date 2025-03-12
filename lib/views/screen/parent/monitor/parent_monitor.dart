import 'package:baby_watcher/views/base/home_app_bar.dart';
import 'package:baby_watcher/views/base/video_widget.dart';
import 'package:flutter/material.dart';

class ParentMonitor extends StatelessWidget {
  const ParentMonitor({super.key});

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
                VideoWidget(
                  url:
                      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                  thumbnail: "assets/images/thumbnail.png",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
