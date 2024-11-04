import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/player/presentation/cubits/video_player_states.dart';
import 'package:tamadrop/features/storage/data/sqflite_storage_repo.dart';

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  final SqfliteStorageRepo sqfliteStorageRepo;
  VideoPlayerCubit({required this.sqfliteStorageRepo})
      : super(VideoPlayerInitial());

  Future<void> getAllVideos() async {
    try {
      emit(VideoPlayerLoading());
      final localVideos = await sqfliteStorageRepo.getAllVideos();
      emit(VideoPlayerLoaded(localVideos));
    } catch (e) {
      emit(VideoPlayerError(e.toString()));
    }
  }
}
