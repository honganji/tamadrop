abstract class VideoState {}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoDownloading extends VideoState {
  final double progress;
  VideoDownloading(this.progress);
}

class VideoLoaded extends VideoState {}

class VideoError extends VideoState {
  final message;
  VideoError(this.message);
}

class VideoDeleting extends VideoState {
  final String vid;
  VideoDeleting(this.vid);
}

class VideoDeleted extends VideoState {}
