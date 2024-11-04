import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/download/data/download_video_repo.dart';
import 'package:tamadrop/features/download/domain/entities/video.dart';
import 'package:tamadrop/features/download/presentation/cubits/video_states.dart';
import 'package:tamadrop/features/storage/domain/repos/storage_repo.dart';

class VideoCubit extends Cubit<VideoState> {
  final DownloadVideoRepo downloadVideoRepo;
  final StorageRepo storageRepo;
  LocalVideo? _localVideo;
  VideoCubit({
    required this.downloadVideoRepo,
    required this.storageRepo,
  }) : super(VideoInitial());

  LocalVideo? get localVideo => _localVideo;

  Future<void> downloadVideo(String url) async {
    try {
      emit(VideoLoading());
      _localVideo = await downloadVideoRepo.downloadVideo(url);
      if (_localVideo != null) {
        storageRepo.storeVideo(_localVideo!);
      } else {
        emit(VideoError("couldn't store video properly"));
      }
      emit(VideoLoaded());
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }
}