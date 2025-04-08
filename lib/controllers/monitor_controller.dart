import 'dart:io';
import 'package:baby_watcher/controllers/api_service.dart';
import 'package:baby_watcher/models/video_model.dart';
import 'package:baby_watcher/utils/formatter.dart';
import 'package:baby_watcher/utils/show_snackbar.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';

class MonitorController extends GetxController {
  final api = Get.find<ApiService>();
  var requestsCount = 0.obs;
  RxInt unseenVideos = 0.obs;
  Rxn<DateTime> lastTime = Rxn();
  Rxn<DateTime> sleepingSince = Rxn();
  Rx<bool> isAwake = RxBool(false);
  RxList<VideoModel> videos = RxList();
  int page = 1;
  bool loadMoreVideo = true;
  Duration totalSleep = Duration();
  RxBool loadingVideos = false.obs;

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
    Map<String, dynamic>? response;

    if (isAwake.value) {
      sleepingSince.value = DateTime.now();

      response = await api.postRequest("/sleep-alert/save", {
        "time": sleepingSince.value.toString(),
        "duration": totalSleep.toString(),
        'type': "sleep",
      }, authRequired: true);
      await api.postRequest("/sleep-alert/send", {
        "time": Formatter.timeFormatter(dateTime: DateTime.now()),
        "type": "sleeping",
      }, authRequired: true);
    } else {
      if (sleepingSince.value != null) {
        Duration newSleep = DateTime.now().difference(sleepingSince.value!);
        totalSleep += newSleep;
      }
      sleepingSince.value = DateTime.now();
      response = await api.postRequest("/sleep-alert/save", {
        "time": sleepingSince.value.toString(),
        "duration": totalSleep.toString(),
        'type': "awake",
      }, authRequired: true);
      await api.postRequest("/sleep-alert/send", {
        "time": Formatter.timeFormatter(dateTime: DateTime.now()),
        "type": "awake",
      }, authRequired: true);
    }

    if (response != null && response["success"] == true) {
      isAwake.value = !isAwake.value;
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
      final type = response['data']['type'];

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

      if (type != "sleep") {
        isAwake.value = true;
      } else {
        isAwake.value = false;
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
    File? thumbnailFile;

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

    try {
      thumbnailFile = await VideoCompress.getFileThumbnail(
        videoFile.path,
        quality: 90,
      );
    } catch (e) {
      showSnackBar(e.toString());
    }

    final response = await api.postRequest(
      "/video/send",
      {"media": fileToUpload, "image": thumbnailFile},
      isMultiPart: true,
      authRequired: true,
    );

    if (response != null && response["success"] == true) {
      requestsCount.value = 0;
      return "Success";
    } else {
      return response?["message"] ?? "Unknown Error";
    }
  }

  String getTotalSleep() {
    if (isAwake.value) {
      return Formatter.durationFormatter(totalSleep);
    }

    var duration = totalSleep;
    if (sleepingSince.value != null) {
      Duration newSleep = DateTime.now().difference(sleepingSince.value!);
      duration += newSleep;
    }

    return Formatter.durationFormatter(duration);
  }

  Future<String> getVideos({int n = 1}) async {
    loadingVideos.value = true;
    final response = await api.getRequest(
      "/video/get-my-video",
      params: {"page": n.toString()},
      authRequired: true,
    );

    loadingVideos.value = false;
    if (response != null && response["success"] == true) {
      final result = response['data']['result'];
      unseenVideos.value = 0;
      for (var i in result) {
        var newVideo = VideoModel.fromJson(i);

        // Check if the video is already in the list based on its unique ID
        if (!videos.any((video) => video.id == newVideo.id)) {
          videos.add(newVideo);
        }

        if (!newVideo.isSeen) {
          unseenVideos.value += 1;
        }
      }

      if (response['data']['meta']['total'] != videos.length) {
        page++;
      } else {
        loadMoreVideo = false;
      }

      return "Success";
    } else {
      loadingVideos.value = false;
      return response?["message"] ?? "Unknown Error";
    }
  }

  Future<void> videoViewed(String id) async {
    final response = await api.updateRequest(
      "/video/update-video-seen-status/$id",
      {},
      authRequired: true,
    );

    if (response != null && response['success'] == true) {
      int index = videos.indexWhere((i) => i.id == id);
      if (index != -1) {
        if (!videos[index].isSeen) {
          unseenVideos.value -= 1;
        }
        videos[index] = videos[index].copyWith(isSeen: true);
      }
    }
  }

  void getMoreVideos() {
    if (loadMoreVideo && page > 0) {
      getVideos(n: page);
    }
  }
}
