// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:baby_watcher/utils/app_colors.dart';
import 'package:baby_watcher/utils/app_icons.dart';
import 'package:baby_watcher/utils/formatter.dart';
import 'package:baby_watcher/views/base/custom_button.dart';
import 'package:baby_watcher/views/base/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibration/vibration.dart';

class BabysitterMonitor extends StatefulWidget {
  const BabysitterMonitor({super.key});

  @override
  State<BabysitterMonitor> createState() => _BabysitterMonitorState();
}

class _BabysitterMonitorState extends State<BabysitterMonitor> {
  bool runTimer = false;
  bool missed = false;
  bool babySleeping = false;
  File? _videoFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
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
                Text(
                  runTimer
                      ? "New Video Request!"
                      : missed
                      ? "You've missed a video request\nSend it now!"
                      : "No video request at\nthis moment",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 500)],
                    fontSize: 24,
                    color: AppColors.indigo[700],
                  ),
                ),
                if (runTimer)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: CustomTimerWidget(
                      initialTime: Duration(seconds: 5),
                      onComplete: () {
                        setState(() {
                          runTimer = false;
                        });

                        if (_videoFile == null) {
                          setState(() {
                            missed = true;
                          });
                        } else {
                          _videoFile = null;
                        }
                      },
                    ),
                  ),
                const SizedBox(height: 28),
                CustomButton(
                  text: "Start Recording",
                  leading: AppIcons.video,
                  radius: 8,
                  isDisabled: (!runTimer && !missed),
                  onTap: () async {
                    if (runTimer || missed) {
                      await _pickVideo();
                      if (_videoFile != null) {
                        final snackBar = SnackBar(
                          content: const Text(
                            "📤 Video Sent to Parents",
                            style: TextStyle(fontSize: 16),
                          ),
                          duration: const Duration(seconds: 3),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 10,
                            left: 20,
                            right: 20,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        setState(() {
                          runTimer = false;
                          missed = false;
                        });
                      }
                    } else {
                      setState(() {
                        runTimer = !runTimer;
                      });
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 16),
                  child: Row(
                    children: [
                      Text(
                        "Track Sleep",
                        style: TextStyle(
                          fontVariations: [FontVariation("wght", 400)],
                          fontSize: 14,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                SleepButton(
                  isAwake: !babySleeping,
                  timeText: "2h 35m",
                  onChange: (p0) async {
                    if (await Vibration.hasVibrator()) {
                      Vibration.vibrate(duration: 500);
                    }
                    setState(() {
                      babySleeping = !p0;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  babySleeping
                      ? "Hold to deactivate sleep tracking"
                      : "Hold to activate sleep tracking",
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 600)],
                    fontSize: 20,
                    color: AppColors.indigo[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Total: 4h 21m",
                  style: TextStyle(
                    fontVariations: [FontVariation("wght", 600)],
                    fontSize: 20,
                    color: AppColors.indigo[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SleepButton extends StatefulWidget {
  final bool isAwake;
  final String timeText;
  final void Function(bool) onChange;
  const SleepButton({
    super.key,
    this.isAwake = true,
    required this.timeText,
    required this.onChange,
  });

  @override
  State<SleepButton> createState() => _SleepButtonState();
}

class _SleepButtonState extends State<SleepButton> {
  final Duration reqTime = Duration(seconds: 1);
  late Timer timer;
  Duration remTime = Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        timer = Timer.periodic(Duration(milliseconds: 100), (val) {
          if (remTime > Duration()) {
            setState(() {
              remTime -= Duration(milliseconds: 100);
            });
          } else {
            widget.onChange(!widget.isAwake);
            timer.cancel();
          }
        });
      },
      onTapUp: (details) {
        timer.cancel();
        setState(() {
          remTime = reqTime;
        });
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.width / 2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.indigo[100],
                shape: BoxShape.circle,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SvgPicture.asset(
                          widget.isAwake ? AppIcons.awake : AppIcons.asleep,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          widget.isAwake ? "Awake" : widget.timeText,
                          style: TextStyle(
                            fontVariations: [FontVariation("wght", 500)],
                            fontSize: 24,
                            color: AppColors.gray[600],
                            height: 1,
                          ),
                        ),
                        if (!widget.isAwake)
                          Text(
                            "of sleeping",
                            style: TextStyle(
                              fontVariations: [FontVariation("wght", 400)],
                              fontSize: 14,
                              color: AppColors.gray[400],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CircularProgressIndicator(
              value: remTime.inMilliseconds / reqTime.inMilliseconds,
              color:
                  widget.isAwake
                      ? AppColors.indigo[200]
                      : AppColors.indigo[400],
              strokeCap: StrokeCap.round,
              backgroundColor: AppColors.indigo[100],
              strokeWidth: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTimerWidget extends StatefulWidget {
  final Duration initialTime;
  final void Function()? onComplete;
  const CustomTimerWidget({
    super.key,
    required this.initialTime,
    this.onComplete,
  });

  @override
  State<CustomTimerWidget> createState() => _CustomTimerWidgetState();
}

class _CustomTimerWidgetState extends State<CustomTimerWidget> {
  late Timer timer;
  late Duration time;

  @override
  void initState() {
    super.initState();
    time = widget.initialTime;
    timer = Timer.periodic(const Duration(seconds: 1), (val) {
      if (time > Duration()) {
        setState(() {
          time -= Duration(seconds: 1);
        });
      } else {
        if (widget.onComplete != null) {
          widget.onComplete!();
        }
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.width / 2,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: time.inSeconds / widget.initialTime.inSeconds,
            strokeWidth: 18,
            strokeCap: StrokeCap.round,
            color: AppColors.indigo[400],
            backgroundColor: AppColors.indigo[50],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Formatter.countdown(time),
                style: TextStyle(
                  fontVariations: [FontVariation("wght", 600)],
                  fontSize: 48,
                  color: AppColors.gray[700],
                  height: 1,
                ),
              ),
              Text(
                "Time remaining",
                style: TextStyle(
                  fontVariations: [FontVariation("wght", 400)],
                  fontSize: 10,
                  color: AppColors.gray[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
