import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/playlist/domain/entities/playlist.dart';
import 'package:tamadrop/features/storage/domain/repos/storage_repo.dart';

class PlaylistCubit extends Cubit<bool> {
  StorageRepo storageRepo;
  List<Playlist>? _playlists;
  PlaylistCubit(this.storageRepo) : super(false);

  List<Playlist> get playlists => _playlists ?? [];

  Future<void> getAllPlaylists() async {
    emit(false);
    var mapList = await storageRepo.getAllPlaylists();
    _playlists = mapList.map((json) => Playlist.fromJson(json)).toList();
    emit(true);
  }
}
