import 'dart:io';
import 'package:baby_watcher/controllers/api_service.dart';
import 'package:baby_watcher/utils/formatter.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';

class MonitorController extends GetxController {
  final api = Get.find<ApiService>();
  var requestsCount = 0.obs;
  Rxn<DateTime> lastTime = Rxn();
  Rxn<DateTime> sleepingSince = Rxn();
  Duration totalSleep = Duration();

  @override
  void onInit() {
    super.onInit();
    getRequest();
    getSleepData();
  }

  Future<String> sendRequest() async {
    final response = await api.postRequest(
      "/video-req/send-req",
      {},
      authRequired: true,
    );

    if (response != null && response["success"] == true) {
      return "Success";
    } else {
      return response?["message"] ?? "Unknown Error";
    }
  }

  Future<String> getRequest() async {
    final response = await api.getRequest(
      "/video-req/get-req",
      authRequired: true,
    );

    if (response != null && response["success"] == true) {
      final data = response['data'];

      if ((data as List).isNotEmpty) {
        requestsCount.value = data.length;

        for (var i in data) {
          var thisTime = DateTime.parse(i['createdAt']);
          lastTime.value =
              lastTime.value == null
                  ? thisTime
                  : thisTime.isAfter(lastTime.value!)
                  ? thisTime
                  : lastTime.value;
        }
      }

      return "Success";
    } else {
      return response?["message"] ?? "Unknown Error";
    }
  }

  Future<String> trackSleep() async {
    bool isSleeping = sleepingSince.value != null;

    Map<String, dynamic>? response;

    if (isSleeping) {
      Duration newSleep = DateTime.now().difference(sleepingSince.value!);
      sleepingSince.value = null;
      totalSleep += newSleep;

      response = await api.postRequest("/sleep-alert/save", {
        "time": sleepingSince.value.toString(),
        "duration": totalSleep.toString(),
      }, authRequired: true);
    } else {
      sleepingSince.value = DateTime.now();
      response = await api.postRequest("/sleep-alert/save", {
        "time": sleepingSince.value.toString(),
        "duration": totalSleep.toString(),
      }, authRequired: true);
      await api.postRequest("/sleep-alert/send", {
        "time": Formatter.timeFormatter(dateTime: DateTime.now()),
      }, authRequired: true);
    }

    if (response != null && response["success"] == true) {
      return "Success";
    } else {
      return response?["message"] ?? "Unknown Error";
    }
  }

  Future<void> getSleepData() async {
    final response = await api.getRequest(
      "/sleep-alert/get",
      authRequired: true,
    );

    if (response != null && response["success"] == true) {
      final time = DateTime.tryParse(response['data']['time']);
      final updatedAt = DateTime.tryParse(response['data']['updatedAt']);
      final durationString = response['data']['duration'];

      Duration? duration;

      if (durationString != null) {
        final parts = durationString.split(RegExp(r"[:.]"));
        if (parts.length == 4) {
          duration = Duration(
            hours: int.parse(parts[0]),
            minutes: int.parse(parts[1]),
            seconds: int.parse(parts[2]),
          );
        }
      }

      if (updatedAt != null &&
          updatedAt.day != DateTime.now().day &&
          updatedAt.month != DateTime.now().month &&
          updatedAt.year != DateTime.now().year) {
        duration = Duration.zero;
      }

      totalSleep = duration ?? Duration.zero;
      sleepingSince.value = time;
    }
  }

  Future<String> sendVideo(
    File videoFile, {
    bool needCompression = true,
  }) async {
    File fileToUpload = videoFile;

    if (needCompression) {
      try {
        final MediaInfo? compressedVideo = await VideoCompress.compressVideo(
          videoFile.path,
          quality: VideoQuality.MediumQuality,
          includeAudio: true,
          frameRate: 30,
        );

        if (compressedVideo != null && compressedVideo.file != null) {
          fileToUpload = compressedVideo.file!;
        }
      } catch (e) {
        return "Compression failed: ${e.toString()}";
      }
    }

    final response = await api.postRequest(
      "/video/send",
      {"media": fileToUpload},
      isMultiPart: true,
      authRequired: true,
    );

    if (response != null && response["success"] == true) {
      return "Success";
    } else {
      return response?["message"] ?? "Unknown Error";
    }
  }

  String getTotalSleep() {
    var duration = totalSleep;
    if (sleepingSince.value != null) {
      Duration newSleep = DateTime.now().difference(sleepingSince.value!);
      duration += newSleep;
    }

    return Formatter.durationFormatter(duration);
  }
}
