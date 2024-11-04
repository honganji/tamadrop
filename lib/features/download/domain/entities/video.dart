import 'dart:convert';

class LocalVideo {
  String vid;
  String path;
  List<String> playlistIDs;
  DateTime lastPlayedAt;
  String thumbnailFilePath;
  String title;
  int volume;
  int length;

  LocalVideo({
    required this.vid,
    required this.path,
    required this.playlistIDs,
    required this.lastPlayedAt,
    required this.thumbnailFilePath,
    required this.title,
    required this.volume,
    required this.length,
  });

  Map<String, dynamic> toJson() {
    return {
      "vid": vid,
      "path": path,
      "playlist_ids": jsonEncode(playlistIDs),
      "last_play_at": lastPlayedAt.toIso8601String(),
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
      playlistIDs: List<String>.from(jsonDecode(json["playlist_ids"])),
      lastPlayedAt: DateTime.parse(json["last_play_at"]),
      thumbnailFilePath: json["thumbnail_file_path"],
      title: json["title"],
      volume: json["volume"],
      length: json["length"],
    );
  }
}
