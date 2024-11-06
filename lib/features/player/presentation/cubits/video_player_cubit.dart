import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/download/domain/entities/video.dart';
import 'package:tamadrop/features/player/presentation/cubits/video_player_states.dart';
import 'package:tamadrop/features/storage/data/sqflite_storage_repo.dart';

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  final SqfliteStorageRepo sqfliteStorageRepo;
  List<LocalVideo>? _videoLists;
  VideoPlayerCubit({required this.sqfliteStorageRepo})
      : super(VideoPlayerInitial());

  List<LocalVideo> get videoList => _videoLists ?? [];

  Future<void> getAllVideos() async {
    try {
      emit(VideoPlayerLoading());
      _videoLists = await sqfliteStorageRepo.getAllVideos();
      emit(VideoPlayerLoaded(_videoLists!));
    } catch (e) {
      emit(VideoPlayerError(e.toString()));
    }
  }

  Future<void> getCategorizedVideo(int pid) async {
    try {
      emit(VideoPlayerLoading());
      _videoLists = await sqfliteStorageRepo.getAllVideos();
      emit(VideoPlayerLoaded(_videoLists!));
    } catch (e) {
      emit(VideoPlayerError(e.toString()));
    }
  }
}
