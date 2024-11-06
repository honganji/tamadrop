import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/playlist/domain/entities/playlist.dart';
import 'package:tamadrop/features/playlist/presentation/cubits/playlist_states.dart';
import 'package:tamadrop/features/storage/domain/repos/storage_repo.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  StorageRepo storageRepo;
  List<Playlist>? _playlists;
  PlaylistCubit(this.storageRepo) : super(PlaylistInitial());

  List<Playlist> get playlists => _playlists ?? [];

  Future<void> getAllPlaylists() async {
    emit(PlaylistLoading());
    var mapList = await storageRepo.getAllPlaylists();
    _playlists = mapList.map((json) => Playlist.fromJson(json)).toList();
    emit(PlaylistLoaded());
  }

  Future<void> addPlaylist(String name) async {
    emit(PlaylistLoading());
    try {
      await storageRepo.addPlaylist(name);
      await getAllPlaylists(); // Re-fetch playlists after adding
    } catch (e) {
      emit(PlaylistError(e.toString()));
    }
  }
}
