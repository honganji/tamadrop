class LocalVideo {
  String vid;
  String path;
  DateTime createdAt;
  String thumbnailFilePath;
  String title;
  int volume;
  int length;

  LocalVideo({
    required this.vid,
    required this.path,
    required this.createdAt,
    required this.thumbnailFilePath,
    required this.title,
    required this.volume,
    required this.length,
  });

  Map<String, dynamic> toJson() {
    return {
      "vid": vid,
      "path": path,
      "created_at": createdAt.toIso8601String(),
      "thumbnail_file_path": thumbnailFilePath,
      "title": title,
      "volume": volume,
      "length": length,
    };
  }

  factory LocalVideo.fromJson(Map<String, dynamic> json) {
    return LocalVideo(
      vid: json["vid"],
      path: json["path"],
      createdAt: DateTime.parse(json["created_at"]),
      thumbnailFilePath: json["thumbnail_file_path"],
      title: json["title"],
      volume: json["volume"],
      length: json["length"],
    );
  }
}
