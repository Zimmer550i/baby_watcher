// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:baby_watcher/controllers/monitor_controller.dart';
import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class VideoWidget extends StatefulWidget {
  final String url;
  final String? thumbnail;
  final String? id;
  const VideoWidget({super.key, required this.url, this.thumbnail, this.id});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController controller;
  late ValueNotifier<bool> _isBuffering;

  @override
  void initState() {
    super.initState();
    _isBuffering = ValueNotifier<bool>(false);
  }

  Future<void> _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    );
    await _videoPlayerController.initialize();
    _videoPlayerController.addListener(() {
      _isBuffering.value = _videoPlayerController.value.isBuffering;
    });
    controller = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: CustomVideoPlayerSettings(
        placeholderWidget: Hero(
          tag: "video",
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.thumbnail != null)
                Image.asset(widget.thumbnail!)
              else
                Container(color: AppColors.gray[300]),
              CircularProgressIndicator(),
            ],
          ),
        ),
        settingsButtonAvailable: false,
        durationAfterControlsFadeOut: Duration(seconds: 3),
        customVideoPlayerProgressBarSettings:
            CustomVideoPlayerProgressBarSettings(
              bufferedColor: AppColors.indigo[100]!,
              progressColor: AppColors.indigo[500]!,
              backgroundColor: AppColors.indigo[25]!,
              progressBarHeight: 4,
            ),
        // customAspectRatio: 16 / 9,
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
  void dispose() {
    super.dispose();
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
              color: AppColors.gray[300],
              image:
                  widget.thumbnail != null
                      ? DecorationImage(
                        image: NetworkImage(widget.thumbnail!),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child: Center(child: SvgPicture.asset(AppIcons.play)),
          );
        },
      ),
    );
  }

  Future<void> playVideo(BuildContext context) async {
    if (widget.id != null) {
      Get.find<MonitorController>().videoViewed(widget.id!);
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColors.gray[800]!.withAlpha(230),
      builder: (context) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.gray[300],
                  image:
                      widget.thumbnail != null
                          ? DecorationImage(
                            image: NetworkImage(widget.thumbnail!),
                            fit: BoxFit.cover,
                          )
                          : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        );
      },
    );

    await _initializeVideoPlayer();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        barrierColor: AppColors.gray[800]!.withAlpha(230),
        builder: (context) {
          return SafeArea(
            child: Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 64),
              insetAnimationDuration: Duration(milliseconds: 300),
              backgroundColor: Colors.transparent,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomVideoPlayer(
                      customVideoPlayerController: controller,
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: _isBuffering,
                    builder: (context, isBuffering, child) {
                      return isBuffering
                          ? Center(
                            child: CircularProgressIndicator(),
                          )
                          : Container();
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: controller.areControlsVisible,
                    builder: (context, isVisible, child) {
                      return Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            }

                            // downloadVideo(widget.url);
                            showSnackBar(
                              "This feature has not been initialized",
                            );
                          },
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: isVisible ? 1 : 0,
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
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void downloadVideo(String url) async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        showSnackBar("Failed to get download directory.");
        return;
      }

      final fileName = Uri.parse(url).pathSegments.last;
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      if (await file.exists()) {
        showSnackBar("Video already downloaded.");
        return;
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);

        showSnackBar("Video downloaded successfully.");
      } else {
        showSnackBar(
          "Failed to download video. Status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      showSnackBar("An error occurred: $e");
    }
  }
}
