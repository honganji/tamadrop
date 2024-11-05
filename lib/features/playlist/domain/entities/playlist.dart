class Playlist {
  final int pid;
  final String name;
  Playlist({required this.pid, required this.name});

  Map<String, dynamic> toJson() {
    return {
      "pid": pid,
      "name": name,
    };
  }

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      pid: json["pid"],
      name: json["name"],
    );
  }
}
