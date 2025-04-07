import 'dart:convert';

VideoModel videoModelFromJson(String str) => VideoModel.fromJson(json.decode(str));

String videoModelToJson(VideoModel data) => json.encode(data.toJson());

class VideoModel {
    String id;
    String babySitterId;
    String parentId;
    String video;
    int count;
    String videoReqId;
    bool isSeen;
    DateTime createdAt;
    DateTime updatedAt;
    int v;
    String? thumbnail;

    VideoModel({
        required this.id,
        required this.babySitterId,
        required this.parentId,
        required this.video,
        required this.count,
        required this.videoReqId,
        required this.isSeen,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        this.thumbnail,
    });

    VideoModel copyWith({
        String? id,
        String? babySitterId,
        String? parentId,
        String? video,
        int? count,
        String? videoReqId,
        bool? isSeen,
        DateTime? createdAt,
        DateTime? updatedAt,
        int? v,
        String? thumbnail,
    }) => 
        VideoModel(
            id: id ?? this.id,
            babySitterId: babySitterId ?? this.babySitterId,
            parentId: parentId ?? this.parentId,
            video: video ?? this.video,
            count: count ?? this.count,
            videoReqId: videoReqId ?? this.videoReqId,
            isSeen: isSeen ?? this.isSeen,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            v: v ?? this.v,
            thumbnail: thumbnail ?? this.thumbnail,
        );

    factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        id: json["_id"],
        babySitterId: json["babySitterId"],
        parentId: json["parentId"],
        video: json["video"],
        count: json["count"],
        videoReqId: json["videoReqId"],
        isSeen: json["isSeen"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        thumbnail: json["thumbnail"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "babySitterId": babySitterId,
        "parentId": parentId,
        "video": video,
        "count": count,
        "videoReqId": videoReqId,
        "isSeen": isSeen,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "thumbnail": thumbnail,
    };
}
