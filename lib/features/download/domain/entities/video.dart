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
}
