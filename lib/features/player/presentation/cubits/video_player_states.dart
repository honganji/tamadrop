import 'package:tamadrop/features/download/domain/entities/video.dart';

abstract class VideoPlayerState {}

class VideoPlayerInitial extends VideoPlayerState {}

class VideoPlayerLoading extends VideoPlayerState {}

class VideoPlayerLoaded extends VideoPlayerState {
  final List<LocalVideo> localVideos;
  VideoPlayerLoaded(this.localVideos);
}

class VideoPlayerError extends VideoPlayerState {
  final String message;
  VideoPlayerError(this.message);
}
