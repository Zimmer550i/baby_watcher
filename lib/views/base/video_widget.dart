import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VideoWidget extends StatefulWidget {
  final String url;
  final String thumbnail;
  const VideoWidget({super.key, required this.url, required this.thumbnail});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      )
      ..initialize().then((val) {
        setState(() {});
        _videoPlayerController.play();
      });
    controller = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: CustomVideoPlayerSettings(
        placeholderWidget: Hero(
          tag: "video",
          child: Image.asset(widget.thumbnail),
        ),
        settingsButtonAvailable: false,
        durationAfterControlsFadeOut: Durations.medium4,
        customVideoPlayerProgressBarSettings:
            CustomVideoPlayerProgressBarSettings(
              bufferedColor: AppColors.indigo[100]!,
              progressColor: AppColors.indigo[500]!,
              backgroundColor: AppColors.indigo[25]!,
              progressBarHeight: 4,
            ),
        customAspectRatio: 16 / 9,
        durationPlayedTextStyle: TextStyle(
          fontVariations: [FontVariation("wght", 400)],
          fontSize: 12,
          color: AppColors.indigo[25],
        ),
        durationRemainingTextStyle: TextStyle(
          fontVariations: [FontVariation("wght", 400)],
          fontSize: 12,
          color: AppColors.indigo[25],
        ),
        controlBarPadding: EdgeInsets.all(0),
        controlsPadding: EdgeInsets.all(0),
        controlBarDecoration: BoxDecoration(
          color: AppColors.gray.withAlpha(100),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        playVideo(context);
      },
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Container(
            constraints: BoxConstraints(minHeight: constraint.maxWidth / 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(widget.thumbnail),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(child: SvgPicture.asset(AppIcons.play)),
          );
        },
      ),
    );
  }

  Future<dynamic> playVideo(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: AppColors.gray[800]!.withAlpha(230),
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(16),
          insetAnimationDuration: Duration(milliseconds: 300),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomVideoPlayer(
                  customVideoPlayerController: controller,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: AppColors.gray.withAlpha(100),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppIcons.download,
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
